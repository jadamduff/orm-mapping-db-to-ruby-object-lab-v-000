class Student
  attr_accessor :id, :name, :grade

  def self.new_from_db(row)
    student = Student.new
    student.id = row[0]
    student.name = row[1]
    student.grade = row[2]
    student
  end

  def self.all
    sql = "SELECT * FROM students;"
    student = DB[:conn].execute(sql).map do |row|
      Student.new_from_db(row)
    end
  end

  def self.all_students_in_grade_9
    sql = "SELECT * FROM students WHERE grade = 9;"
    student = DB[:conn].execute(sql).map do |row|
      Student.new_from_db(row)
    end
  end

  def self.students_below_12th_grade
    sql = "SELECT * FROM students WHERE grade < 12;"
    student = DB[:conn].execute(sql).map do |row|
      Student.new_from_db(row)
    end
  end

  def self.find_by_name(name)
    sql = "SELECT * FROM students WHERE name = ? LIMIT 1;"
    student = DB[:conn].execute(sql, name).first
    Student.new_from_db(student)
  end

  def save
    sql = <<-SQL
      INSERT INTO students (name, grade)
      VALUES (?, ?)
    SQL

    DB[:conn].execute(sql, self.name, self.grade)
  end

  def self.create_table
    sql = <<-SQL
    CREATE TABLE IF NOT EXISTS students (
      id INTEGER PRIMARY KEY,
      name TEXT,
      grade TEXT
    )
    SQL

    DB[:conn].execute(sql)
  end

  def self.drop_table
    sql = "DROP TABLE IF EXISTS students"
    DB[:conn].execute(sql)
  end
end
