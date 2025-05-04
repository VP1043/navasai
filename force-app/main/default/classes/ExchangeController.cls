public with sharing class ExchangeController {
    public ExchangeController() {

    }

    @AuraEnabled
    public static String  convertToBASE64(String ss ) {

       // Blob payloadBlob = EncodingUtil.base64Decode(ss);
        //String payload = payloadBlob.toString();


        String result = EncodingUtil.Base64Encode( Blob.valueOf( ss ) );


        return result;

    }
}