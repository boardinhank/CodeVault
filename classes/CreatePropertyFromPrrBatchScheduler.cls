/***************************************************************
===============================================================
Purpose: Scheduler class for CreatePropertyFromPrrBatch class
===============================================================
History:

AUTHOR      DATE        Reference   Description
Navin M     14/12/2021  ESCJ-327    Initial draft
***************************************************************/
public with sharing class CreatePropertyFromPrrBatchScheduler implements Schedulable {
    static final Integer BATCH_SIZE_DEFAULT = 1;
    public static final String BATCH_SIZE_KEY = 'CreatePropertyFromPrrBatch.batchSize';
    public static Integer BATCH_SIZE {
        get {
            if(BATCH_SIZE == null) {
                BATCH_SIZE = Integer.valueOf(
                    ConfigKeyValuePairMetadata.getMetadata(
                        BATCH_SIZE_KEY,
                        BATCH_SIZE_DEFAULT
                    )
                );
            }
            return BATCH_SIZE;
        }
        set;
    }

    public void execute(SchedulableContext sc) {
        Database.executeBatch(
            new CreatePropertyFromPrrBatch(), 
            BATCH_SIZE
        );
    }
}