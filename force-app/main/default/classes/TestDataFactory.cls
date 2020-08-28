public without sharing class TestDataFactory {
    
    public static List<Case> createCases(Integer count) {
        list<Case> cases = new List<Case>();
        for (Integer i = 0; i < count; i++) {
            case c = new case();
            c.Origin = 'Web';
            c.status = 'new';
            c.subject = 'case' + string.valueof(i);
            cases.add(c);
        }

        return cases;
    }
}
