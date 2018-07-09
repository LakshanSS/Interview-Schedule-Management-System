
# Interview-Schedule-Management-System

System for HR department to manage interview schedules for candidates and interviewers.
<h3>Prerequisites</h3>
1.Visit Google API Console, click Create Project, and follow the wizard to create a new project.<br>
2.Enable both Gmail and Google Sheets APIs for the project.<br>
3.Go to Credentials -> OAuth consent screen, enter a product name to be shown to users, and click Save.<br>
4.On the Credentials tab, click Create credentials and select OAuth client ID.<br>
5.Select an application type, enter a name for the application, and specify a redirect URI (enter https://developers.google.com/oauthplayground if you want to use OAuth 2.0 playground to receive the authorization code and obtain the access token and refresh token).<br>
6.Click Create. Your client ID and client secret appear.<br>
7.In a separate browser window or tab, visit OAuth 2.0 playground, select the required Gmail and Google Sheets API scopes, and then click Authorize APIs.<br>
8.When you receive your authorization code, click Exchange authorization code for tokens to obtain the refresh token and access token.<br>
<h3>Please follow the Steps</h3>
1.Create a Google Sheet as follows from the same Google account you have obtained the client credentials and tokens to access both APIs.Create 2 sheets as shown in the images.<br>

![alt tag](https://github.com/LakshanSS/Interview-Schedule-Management-System/blob/master/images/candidates.png)

![alt tag](https://github.com/LakshanSS/Interview-Schedule-Management-System/blob/master/images/interviewers.png)
<br>2.Create Twilio Account and get Account SID and AuthToken.<br>
3.Add ballerina.config file to the root folder.<br>

![alt tag](https://github.com/LakshanSS/Interview-Schedule-Management-System/blob/master/images/config.png)
<br>4.Run the following command in terminal<br>
$ ballerina run notification-sender

<h3>Problem</h3>
<p>HR Departments in organizations have to shortlist candidates, schedule interviews with interviewers and send invitation mails to candidates and send the details of candidates and schedule to the interviewers. Sending mails for each candidates and interviewers with relevant details is a difficult task for the HR Managers. </p>

<h3>Solution</h3>
<p>The HR Manager can put the interview schedule detail in a Google Sheet. 
The program will be able to
1. Read data from the google sheet,<br>
2. Send invitation email to each candidate with relevant data(time, date, location etc. ), <br>
3. Send email to interviewers with the details of the candidates whom they are going to interview, <br>
4. Send invitation SMS to candidates using Twilio, <br>
5. Send notification SMS to interviewers using Twilio.</p>

<h3>Used Saas Services</h3>
<p>1. Google Sheets<br>
2. Gmail<br>
3. Twilio<br></p>

