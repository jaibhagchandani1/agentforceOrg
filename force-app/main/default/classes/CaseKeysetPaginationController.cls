public with sharing class CaseKeysetPaginationController {

    @AuraEnabled(cacheable=true)
    public static CasePageWrapper getCases(
        Integer pageSize,
        Datetime lastCreatedDate,
        Id lastRecordId,
        Boolean isFirstPage
    ) {

        List<Case> caseList;

        if (isFirstPage == true) {

            caseList = [

                SELECT
                    Id,
                    CaseNumber,
                    Subject,
                    Status,
                    Priority,
                    CreatedDate

                FROM Case

                ORDER BY CreatedDate DESC, Id DESC

                LIMIT :pageSize
            ];

        } else {

            caseList = [

                SELECT
                    Id,
                    CaseNumber,
                    Subject,
                    Status,
                    Priority,
                    CreatedDate

                FROM Case

                WHERE

                    CreatedDate < :lastCreatedDate

                    OR

                    (
                        CreatedDate = :lastCreatedDate
                        AND Id < :lastRecordId
                    )

                ORDER BY CreatedDate DESC, Id DESC

                LIMIT :pageSize
            ];

        }

        return new CasePageWrapper(caseList);

    }

    public class CasePageWrapper {

        @AuraEnabled
        public List<Case> records;

        public CasePageWrapper(List<Case> recs) {

            this.records = recs;

        }

    }

}