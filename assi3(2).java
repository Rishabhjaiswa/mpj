class Hillstations {
    void famousfood() {
        System.out.println("famous food of this hill station.");
    
    }
    void famousfor() {
        System.out.println("This hill station is famour for its scenic beauty.");
    
    }
}

class Ooty extends Hillstations {
    @Override 
    void famousfood() {
        System.out.println("Ooty : Famous for homemade chocolates and varkey.");

    }
    @Override
    void famousfor() {
        System.out.println("Ooty : Famous for Ooty lake and nilgiri tea gardens.");

    }

}

class Munnar extends Hillstations {
    @Override
    void famousfood() {
        System.out.println("Munnar : Famous kerala sadhya and tea biscuits.");

    }
    @Override
    void famousfor() {
        System.out.println("Munnar : Famous for tea plantations and eravikula national park.");

    }
}

class Coorg extends Hillstations {
    @Override
    void famousfood() {
        System.out.println("Coorg : famous for pandi curry and kadambuttu.");

    }
    @Override
    void famousfor() {
        System.out.println("Coorg : famous for coffee estates and abbey falls");

    }
}

public class Main {
    public static void main(String[] args) {
        Hillstations h;

        h = new Ooty();
        h.famousfood();
        h.famousfor();

        System.out.println("---");

        h = new Munnar();
        h.famousfood();
        h.famousfor();

        System.out.println("---");

        h = new Coorg();
        h.famousfood();
        h.famousfor();
    }
}