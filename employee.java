// ================= BASE CLASS =================
class Employee {
    protected String name;
    protected double salary;

    // Constructor (Base class)
    Employee(String name, double salary) {
        this.name = name;
        this.salary = salary;
        System.out.println("Employee constructor called");
    }

    // Method in base class
    public void displaySalary() {
        System.out.println("Employee Name: " + name);
        System.out.println("Salary: " + salary);
    }

    // Destructor equivalent in Java (called by GC)
    @Override
    protected void finalize() throws Throwable {
        System.out.println("Employee object destroyed");
    }
}

// ============ SINGLE INHERITANCE =============
class FullTimeEmployee extends Employee {

    // Constructor
    FullTimeEmployee(String name, double salary) {
        super(name, salary);
        System.out.println("FullTimeEmployee constructor called");
    }

    public void calculateSalary() {
        System.out.println("\n--- Full Time Employee ---");
        System.out.println("Before Hike:");
        displaySalary();

        salary = salary + (salary * 0.50);

        System.out.println("After 50% Hike:");
        displaySalary();
    }

    @Override
    protected void finalize() throws Throwable {
        System.out.println("FullTimeEmployee object destroyed");
    }
}

// ========== HIERARCHICAL INHERITANCE ==========
class InternEmployee extends Employee {

    // Constructor
    InternEmployee(String name, double salary) {
        super(name, salary);
        System.out.println("InternEmployee constructor called");
    }

    public void calculateSalary() {
        System.out.println("\n--- Intern Employee ---");
        System.out.println("Before Hike:");
        displaySalary();

        salary = salary + (salary * 0.25);

        System.out.println("After 25% Hike:");
        displaySalary();
    }

    @Override
    protected void finalize() throws Throwable {
        System.out.println("InternEmployee object destroyed");
    }
}

// ========== MULTILEVEL INHERITANCE ==========
class TraineeIntern extends InternEmployee {

    // Constructor
    TraineeIntern(String name, double salary) {
        super(name, salary);
        System.out.println("TraineeIntern constructor called");
    }

    public void traineeInfo() {
        System.out.println("\n--- Trainee Intern ---");
        displaySalary();
    }

    @Override
    protected void finalize() throws Throwable {
        System.out.println("TraineeIntern object destroyed");
    }
}

// ================= MAIN CLASS =================
class Mai {
    public static void main(String[] args) {

        // Object creation → constructors called
        FullTimeEmployee fte = new FullTimeEmployee("Rishabh", 40000);
        fte.calculateSalary();

        InternEmployee intern = new InternEmployee("Aman", 20000);
        intern.calculateSalary();

        TraineeIntern trainee = new TraineeIntern("Neha", 15000);
        trainee.traineeInfo();

        // Making objects eligible for garbage collection
        fte = null;
        intern = null;
        trainee = null;

        // Requesting garbage collector
        System.gc();
    }
}
