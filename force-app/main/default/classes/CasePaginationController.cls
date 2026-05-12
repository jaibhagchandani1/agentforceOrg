public with sharing class CasePaginationController {

    @AuraEnabled(cacheable=true)
    public static CasePageWrapper getCases(
        Integer pageSize,
        Integer pageNumber
    ) {

        Integer offsetValue =
            (pageNumber - 1) * pageSize;

        List<Case> casesList = [

            SELECT
                Id,
                CaseNumber,
                Subject,
                Status,
                Priority,
                CreatedDate

            FROM Case

            ORDER BY CreatedDate DESC

            LIMIT :pageSize
            OFFSET :offsetValue
        ];

        Integer totalRecords = [
            SELECT COUNT()
            FROM Case
        ];

        CasePageWrapper wrapper =
            new CasePageWrapper();

        wrapper.records = casesList;
        wrapper.totalRecords = totalRecords;

        return wrapper;
    }

    public class CasePageWrapper {

        @AuraEnabled
        public List<Case> records;

        @AuraEnabled
        public Integer totalRecords;

    }
}