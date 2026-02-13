class Student {

    // 1. Data members (private → encapsulation)
    private String name;
    private int marks1;
    private int marks2;
    private int marks3;

    // 2. Constructor (used to initialize object)
    public Student(String name, int m1, int m2, int m3) {
        this.name = name;
        this.marks1 = m1;
        this.marks2 = m2;
        this.marks3 = m3;
    }

    // 3. Method that returns a value
    public double calculatePercentage() {
        int total = marks1 + marks2 + marks3;
        return (total / 300.0) * 100;
    }

    // 4. Method with no return type
    public void checkResult() {
        double percentage = calculatePercentage();

        System.out.println("Student Name: " + name);
        System.out.println("Percentage: " + percentage + "%");

        if (percentage >= 35) {
            System.out.println("Result: PASS");
        } else {
            System.out.println("Result: FAIL");
        }
    }

    // 5. Public getter method
    public String getName() {
        return name;
    }
}

class Main {
    public static void main(String[] args) {

        // 6. Object creation
        Student s1 = new Student("Rishabh", 45, 55, 40);

        // 7. Calling method using object
        s1.checkResult();
    }
}
