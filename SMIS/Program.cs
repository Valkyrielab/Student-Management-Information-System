using System;
using Microsoft.Data.SqlClient;
//using Microsoft.Extensions.Configuration; // For config file

namespace StudentManagementSystem
{
    class Program
    {
        private static string connectionString;

        static void Main(string[] args)
        {
            // Load connection string from App.config or environment variable
            connectionString = "Server=.;Database=StudentManagementDB;Integrated Security=True; TrustServerCertificate=True;Trusted_Connection=True;";

            bool exit = false;
            while (!exit)
            {
                Console.WriteLine("\n=== STUDENT MANAGEMENT SYSTEM ===");
                Console.WriteLine("1. Display all students");
                Console.WriteLine("2. Search for a student");
                Console.WriteLine("3. Register a student");
                Console.WriteLine("4. Enrol a student");
                Console.WriteLine("5. Capture or update a mark");
                Console.WriteLine("6. View student results");
                Console.WriteLine("7. View students without enrolments");
                Console.WriteLine("8. Record a payment");
                Console.WriteLine("9. Exit");
                Console.Write("Select an option: ");

                string choice = Console.ReadLine();
                switch (choice)
                {
                    case "1": DisplayAllStudents(); break;
                    case "2": SearchStudent(); break;
                    case "3": RegisterStudent(); break;
                    case "4": EnrolStudent(); break;
                    case "5": UpdateMark(); break;
                    case "6": ViewStudentResults(); break;
                    case "7": ViewStudentsWithoutEnrolments(); break;
                    case "8": RecordPayment(); break;
                    case "9": exit = true; break;
                    default: Console.WriteLine("Invalid choice."); break;
                }
            }
        }

        // 1. Display all students
        static void DisplayAllStudents()
        {
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                conn.Open();
                string query = "SELECT StudentNumber, FullName, Email, Status FROM STUDENT";
                using (SqlCommand cmd = new SqlCommand(query, conn))
                using (SqlDataReader reader = cmd.ExecuteReader())
                {
                    while (reader.Read())
                    {
                        Console.WriteLine($"{reader["StudentNumber"]} | {reader["FullName"]} | {reader["Email"]} | {reader["Status"]}");
                    }
                }
            }
        }

        // 2. Search for a student
        static void SearchStudent()
        {
            Console.Write("Enter student number: ");
            string studentNumber = Console.ReadLine();

            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                conn.Open();
                string query = "SELECT * FROM STUDENT WHERE StudentNumber = @StudentNumber";
                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@StudentNumber", studentNumber);
                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        if (reader.Read())
                        {
                            Console.WriteLine($"Found: {reader["FullName"]} ({reader["Email"]}) Status: {reader["Status"]}");
                        }
                        else
                        {
                            Console.WriteLine("Student not found.");
                        }
                    }
                }
            }
        }

        // 3. Register a student
        static void RegisterStudent()
        {
            Console.Write("Enter student number: ");
            string number = Console.ReadLine();
            Console.Write("Enter full name: ");
            string name = Console.ReadLine();
            Console.Write("Enter email: ");
            string email = Console.ReadLine();

            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                conn.Open();
                string query = "INSERT INTO STUDENT (StudentNumber, FullName, Email, Status) VALUES (@Number, @Name, @Email, 'Active')";
                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@Number", number);
                    cmd.Parameters.AddWithValue("@Name", name);
                    cmd.Parameters.AddWithValue("@Email", email);

                    try
                    {
                        cmd.ExecuteNonQuery();
                        Console.WriteLine("Student registered successfully.");
                    }
                    catch (SqlException ex)
                    {
                        Console.WriteLine($"Error: {ex.Message}");
                    }
                }
            }
        }

        // 4. Enrol a student
        static void EnrolStudent()
        {
            Console.Write("Enter student ID: ");
            int studentId = int.Parse(Console.ReadLine());
            Console.Write("Enter course ID: ");
            int courseId = int.Parse(Console.ReadLine());

            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                conn.Open();
                string query = "INSERT INTO ENROLMENT (StudentID, CourseID, EnrolmentDate) VALUES (@StudentID, @CourseID, GETDATE())";
                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@StudentID", studentId);
                    cmd.Parameters.AddWithValue("@CourseID", courseId);

                    try
                    {
                        cmd.ExecuteNonQuery();
                        Console.WriteLine("Enrolment successful.");
                    }
                    catch (SqlException ex)
                    {
                        Console.WriteLine($"Error: {ex.Message}");
                    }
                }
            }
        }

        // 5. Capture or update a mark
        static void UpdateMark()
        {
            Console.Write("Enter student ID: ");
            int studentId = int.Parse(Console.ReadLine());
            Console.Write("Enter course ID: ");
            int courseId = int.Parse(Console.ReadLine());
            Console.Write("Enter new mark: ");
            int mark = int.Parse(Console.ReadLine());

            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                conn.Open();
                string query = "UPDATE ENROLMENT SET FinalMark = @Mark WHERE StudentID = @StudentID AND CourseID = @CourseID";
                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@Mark", mark);
                    cmd.Parameters.AddWithValue("@StudentID", studentId);
                    cmd.Parameters.AddWithValue("@CourseID", courseId);

                    int rows = cmd.ExecuteNonQuery();
                    if (rows > 0)
                        Console.WriteLine("Mark updated successfully.");
                    else
                        Console.WriteLine("No enrolment found.");
                }
            }
        }

        // 6. View student results (calls stored procedure)
        static void ViewStudentResults()
        {
            Console.Write("Enter student ID: ");
            int studentId = int.Parse(Console.ReadLine());

            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                conn.Open();
                using (SqlCommand cmd = new SqlCommand("dbo.usp_GetStudentResults", conn))
                {
                    cmd.CommandType = System.Data.CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@StudentID", studentId);

                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        while (reader.Read())
                        {
                            Console.WriteLine($"{reader["CourseCode"]} | {reader["CourseName"]} | {reader["FinalMark"]} | {reader["Result"]}");
                        }
                    }
                }
            }
        }

        // 7. View students without enrolments
        static void ViewStudentsWithoutEnrolments()
        {
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                conn.Open();
                string query = @"
                    SELECT s.StudentNumber, s.FullName
                    FROM STUDENT s
                    LEFT JOIN ENROLMENT e ON s.StudentID = e.StudentID
                    WHERE e.CourseID IS NULL";
                using (SqlCommand cmd = new SqlCommand(query, conn))
                using (SqlDataReader reader = cmd.ExecuteReader())
                {
                    while (reader.Read())
                    {
                        Console.WriteLine($"{reader["StudentNumber"]} | {reader["FullName"]}");
                    }
                }
            }
        }

        // 8. Record a payment
        static void RecordPayment()
        {
            Console.Write("Enter student ID: ");
            int studentId = int.Parse(Console.ReadLine());
            Console.Write("Enter amount: ");
            decimal amount = decimal.Parse(Console.ReadLine());
            Console.Write("Enter reference number: ");
            string reference = Console.ReadLine();

            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                conn.Open();
                string query = "INSERT INTO PAYMENT (StudentID, Amount, PaymentDate, ReferenceNumber) VALUES (@StudentID, @Amount, GETDATE(), @Reference)";
                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@StudentID", studentId);
                    cmd.Parameters.AddWithValue("@Amount", amount);
                    cmd.Parameters.AddWithValue("@Reference", reference);

                    try
                    {
                        cmd.ExecuteNonQuery();
                        Console.WriteLine("Payment recorded successfully.");
                    }
                    catch (SqlException ex)
                    {
                        Console.WriteLine($"Error: {ex.Message}");
                    }
                }
            }
        }
    }
}

