public class LMN_VisualForceErrorMessages {
    
    public LMN_VisualForceErrorMessages(Apexpages.StandardController controller){

        ApexPages.Message err=new Apexpages.Message(Apexpages.Severity.ERROR,'There was an error');
            Apexpages.addMessage(err);
                ApexPages.Message warn=new Apexpages.Message(Apexpages.Severity.WARNING,'Warning');
            Apexpages.addMessage(warn);
                ApexPages.Message info=new Apexpages.Message(Apexpages.Severity.INFO,'Information');
            Apexpages.addMessage(info);
        
    }

}