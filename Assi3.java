class Shapes {
    double dimension1, dimension2;

    Shapes(double side) {
        dimension1 = side;
    }

    Shapes(double d1, double d2) {
        dimension1 = d1;
        dimension2 = d2;
    }

    double area(double radius) {
        return Math.PI * radius * radius;
    }

    double area(double length, double breadth){
        return length * breadth;
    }

    double area(double base, double height, boolean isTriangle) {
        return 0.5 * base * height;
    }

    double area(int side) {
        return side * side;
    }

}

public class Main {
    public static void main(String[] args) {
        Shapes s = new Shapes(5.0);

        System.out.println("Area of Circle    : " + s.area(5.0));
        System.out.println("Area of Rectangle : " + s.area(4.0, 6.0));
        System.out.println("Area of Triangle  : " + s.area(3.0, 8.0, true));
        System.out.println("Area of Square    : " + s.area(4));
    }
} 
    