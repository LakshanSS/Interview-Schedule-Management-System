import ballerina/config;
import ballerina/log;
import wso2/gsheets4;
import wso2/gmail;
import wso2/twilio;

documentation{A valid access token with gmail and google sheets access.}
string accessToken = config:getAsString("ACCESS_TOKEN");

documentation{The client ID for your application.}
string clientId = config:getAsString("CLIENT_ID");

documentation{The client secret for your application.}
string clientSecret = config:getAsString("CLIENT_SECRET");

documentation{A valid refreshToken with gmail and google sheets access.}
string refreshToken = config:getAsString("REFRESH_TOKEN");

documentation{Spreadsheet id of the reference google sheet.}
string spreadsheetId = config:getAsString("SPREADSHEET_ID");

documentation{Sheet name of the reference googlle sheet.}
string sheet1Name = config:getAsString("SHEET1_NAME");

documentation{Sheet name of the reference googlle sheet.}
string sheet2Name = config:getAsString("SHEET2_NAME");

documentation{Sender email address.}
string senderEmail = config:getAsString("SENDER");

documentation{The user's email address.}
string userId = config:getAsString("USER_ID");

documentation{
    Google Sheets client endpoint declaration with http client configurations.
}

endpoint gsheets4:Client spreadsheetClient {
    clientConfig:{
        auth:{
            accessToken:accessToken,
            refreshToken:refreshToken,
            clientId:clientId,
            clientSecret:clientSecret
        }
    }
};


documentation{
    GMail client endpoint declaration with oAuth2 client configurations.
}
endpoint gmail:Client gmailClient {
    clientConfig: {
        auth: {
            accessToken: accessToken,
            refreshToken: refreshToken,
            clientId: clientId,
            clientSecret: clientSecret
        }
    }
};

documentation{
    twilio client configurations.
}
endpoint twilio:Client twilioClient {
    accountSId:config:getAsString("ACCOUNT_SID"),
    authToken:config:getAsString("AUTH_TOKEN"),
    xAuthyKey:config:getAsString("AUTHY_API_KEY")
};


function main(string... args) {
    sendNotification();
}

documentation{
    Send notification to the customers.
}
function sendNotification() {
    //Retrieve the interview details from spreadsheets.
    string[][] sheet1 = getDetailsFromGSheet(sheet1Name);
    string[][] sheet2 = getDetailsFromGSheet(sheet2Name);

    int x = 0;
    //Iterate through each candidate details and send customized email.
    foreach value in sheet1 {
        //Skip the first row as it contains header values.
        if (x > 0) {
            string firstName = value[0];
            string lastName = value[1];
            string position = value[2];
            string candidateEmail = value[3];
            string candidateMobile = value[4];
            string interviewDate = value[5];
            string interviewTime = value[6];
            string interviewLocation = value[7];

            //Email Subject
            string subject = "Interview at ABC Company for " + position+" position";
            sendMail(candidateEmail, subject, candidateEmailTemplate(firstName, interviewDate,interviewTime,position,interviewLocation));
            //Message for SMS
            string message = "Hi "+firstName+",Please kindly attend the interview at "+
                interviewTime+" on "+interviewDate+" at "+ interviewLocation+",ABC Company.";

            var details = twilioClient->sendSms("+13059283569", "+"+candidateMobile, message);
            match details {
                twilio:SmsResponse smsResponse => {
                    log:printDebug("Twilio Connector -> SMS successfully sent to " + candidateMobile);
                }
                twilio:TwilioError err => {
                    log:printDebug("Twilio Connector -> SMS failed sent to " + candidateMobile);
                    log:printError(err.message);
                }
            }
        }
        x = x + 1;
    }

    //Retrive interviewer details and send customized mail
    int y=0;
    foreach value in sheet2  {
        if(y>0){
            string name = value[0];
            string emailAdd = value[2];
            string mobileNo = value[3];
            string id = value[4];
            string mailSubject = "Interview schedule";
            string emailMessage = "<h2> Hi " + name + " </h2>";
            emailMessage=emailMessage+"<h3>You have to interview following people</h3><br>";

            foreach values in sheet1 {
                //Skip the first row as it contains header values.
                if (x > 0) {
                    string firstName = values[0];
                    string lastName = values[1];
                    string position = values[2];
                    string candidateEmail = values[3];
                    string candidateMobile = values[4];
                    string interviewDate = values[5];
                    string interviewTime = values[6];
                    string interviewLocation = values[7];
                    string interviewerID = values[8];

                    if(id==interviewerID){
                        emailMessage=emailMessage+"<h3>"+interviewDate+" "+interviewTime+" "+interviewLocation+" "+
                            firstName+" "+lastName+" for "+position+" position</h3>";
                    }

                }
                x = x + 1;
            }

            //Send email to interviewers
            sendMail(emailAdd, mailSubject, emailMessage);

            //Message for SMS
            string message = "Hi "+name+", You have to interview few candidates. Please check your email for further details";

            var details = twilioClient->sendSms("+13059283569", "+"+mobileNo, message);
            match details {
                twilio:SmsResponse smsResponse => {
                    log:printDebug("Twilio Connector -> SMS successfully sent to " + mobileNo);
                }
                twilio:TwilioError err => {
                    log:printDebug("Twilio Connector -> SMS failed sent to " + mobileNo);
                    log:printError(err.message);
                }
            }
        }
        y=y+1;
    }
}

documentation{
    Retrieves customer details from the spreadsheet statistics.

    R{{}} - Two dimensional string array of spreadsheet cell values.
}

//Method to get data from Google Sheet
function getDetailsFromGSheet(string sheetName) returns (string[][]) {
    //Read all the values from the sheet.
    string[][] values = check spreadsheetClient->getSheetValues(spreadsheetId, sheetName, "A1", "I3");
    log:printInfo("Retrieved details from spreadsheet id:" + spreadsheetId + " ;sheet name: "
            + sheetName);
    return values;
}


function candidateEmailTemplate(string candidateName, string date,string time,string position,string location ) returns (string) {
    string emailTemplate = "<h2> Hi " + candidateName + " </h2>";
    emailTemplate = emailTemplate + "<h3>Thank you for your application for the post of " + position + " ! </h3>";
    emailTemplate = emailTemplate + "<h3> We would like to invite you to attend an interview at " + time +
        " on "+date+" at "+location+" ,ABC Company. We look forward to meet you! </h3> ";
    return emailTemplate;
}

//Method to send email
function sendMail(string receiverEmail, string subject, string messageBody) {
    //Create html message
    gmail:MessageRequest messageRequest;
    messageRequest.recipient = receiverEmail;
    messageRequest.sender = senderEmail;
    messageRequest.subject = subject;
    messageRequest.messageBody = messageBody;
    messageRequest.contentType = gmail:TEXT_HTML;

    //Send mail
    var sendMessageResponse = gmailClient->sendMessage(userId, untaint messageRequest);
    string messageId;
    string threadId;
    match sendMessageResponse {
        (string, string) sendStatus => {
            (messageId, threadId) = sendStatus;
            log:printInfo("Sent email to " + receiverEmail + " with message Id: " + messageId + " and thread Id:"
                    + threadId);
        }
        gmail:GmailError e => log:printInfo(e.message);
    }
}
