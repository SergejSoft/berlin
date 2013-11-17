function insert(item, user, request) {
    console.log(item);
    var httpRequest = require('request');
    var url = 'https://svcs.sandbox.paypal.com/AdaptivePayments/Pay?paykey=AFcWxV21C7fd0v3bYYYRCpSSRl31A2RK8IyC4LqGsow02oVSBa4LZaJG';
    var amount = item["amount"];
    var email = item["paypalEmail"]
    var headers = {
        // Sandbox API credentials for the API Caller account
        'X-PAYPAL-SECURITY-USERID': 'jurrestender-facilitator_api1.hotmail.com',
        'X-PAYPAL-SECURITY-PASSWORD': '1384664630',
        'X-PAYPAL-SECURITY-SIGNATURE': 'AFcWxV21C7fd0v3bYYYRCpSSRl31A2RK8IyC4LqGsow02oVSBa4LZaJG',

        // Global Sandbox Application ID
        'X-PAYPAL-APPLICATION-ID': 'APP-80W284485P519543T',

        // Input and output formats
        'X-PAYPAL-REQUEST-DATA-FORMAT': 'JSON',
        'X-PAYPAL-RESPONSE-DATA-FORMAT': 'JSON'
    }

    httpRequest.post({
        url: url,
        headers: headers,
        json: {
                "senderEmail": "jurrestender-facilitator@hotmail.com",
                "actionType":"PAY",    // Specify the payment action
                "currencyCode":"USD",  // The currency of the payment
                "receiverList": {
                    "receiver": [{
                    "amount": amount,                    // The payment amount
                    "email":"jurrestender@hotmail.com"}]  // The payment Receiver's email address
                },
                "returnUrl": "http://localhost:8000",
                "cancelUrl": "http://localhost:8000",
                "requestEnvelope": {
                    "errorLanguage":"en_US",    // Language used to display errors
                    "detailLevel":"ReturnAll"   // Error detail level
                }
            }
        }, function (error, response, body) {
            if (!error && response.statusCode == 200) {
                console.log(body)
            }
        }
    );
    request.execute();
}
