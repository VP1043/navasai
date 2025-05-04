public class PDFGeneratorAndEmailer {
    @AuraEnabled
    public static void generatePDFAndSendEmail(String month, String recipientEmail,String year) {
        // Render the Visualforce page as PDF
        PageReference pageRef = new PageReference('/apex/PDFDocument');
        pageRef.getParameters().put('Month', month);
        pageRef.getParameters().put('Year', year); // Pass any necessary parameters
        Blob pdfBlob = pageRef.getContentAsPDF();

        // Create an email with the PDF attachment
        Messaging.EmailFileAttachment attachment = new Messaging.EmailFileAttachment();
        attachment.setFileName('Rent Statement '+month+'-'+year+'.pdf');
        attachment.setBody(pdfBlob);

        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
        email.setToAddresses(new List<String>{recipientEmail});
        email.setSubject('Rent Statement '+month+'-'+year);
        email.setPlainTextBody('Please find the attached PDF.');

        // Attach the PDF to the email
        email.setFileAttachments(new List<Messaging.EmailFileAttachment>{attachment});

        // Send the email
        Messaging.sendEmail(new List<Messaging.Email>{email});
    }
}