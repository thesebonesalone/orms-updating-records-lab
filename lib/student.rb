require_relative "../config/environment.rb"

class Student
  attr_accessor :name, :grade, :id
  def self.create_table
    sql = <<-SQL
    CREATE TABLE IF NOT EXISTS students (
      id INTEGER PRIMARY KEY,
      name TEXT,
      grade INTEGER
    )
    SQL
    DB[:conn].execute(sql)
  end
  def self.drop_table
    sql = <<-SQL
    DROP TABLE IF EXISTS students
    SQL
    DB[:conn].execute(sql)
  end
  def initialize(name,grade,id = nil)
    @name = name
    @grade = grade
    @id = id
  end
  def save
    if @id == nil
      sql = <<-SQL
      INSERT INTO students (name, grade)
      VALUES (?, ?)
      SQL
      DB[:conn].execute(sql, @name, @grade)
      @id = DB[:conn].execute("SELECT id FROM students ORDER BY id DESC LIMIT 1")[0][0]
    else
      sql = <<-SQL
      UPDATE students
      SET name = ?, grade = ?
      WHERE
      id = ?
      SQL
      DB[:conn].execute(sql, @name, @grade, @id)
    end
  end
  def self.create(name, grade)
    new_student = Student.new(name, grade)
    sql = <<-SQL
      INSERT INTO students (name, grade)
      VALUES (?, ?)
      SQL
    DB[:conn].execute(sql, new_student.name, new_student.grade)
    new_student.id = DB[:conn].execute("SELECT id FROM students ORDER BY id DESC LIMIT 1")[0][0]
  end
  def self.new_from_db(row)
    new_student = Student.new(row[1],row[2])
    new_student.id = row[0]
    new_student
  end
  def self.find_by_name(name)
    sql = <<-SQL
    SELECT * FROM students WHERE name = ? LIMIT 1
    SQL
    self.new_from_db(DB[:conn].execute(sql, name)[0])
  end
  def update
    sql = <<-SQL
    UPDATE students
    SET name = ?, grade = ?
    WHERE
    id = ?
    SQL
    DB[:conn].execute(sql, @name, @grade, @id)
  end




end
