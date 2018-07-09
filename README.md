# Interview-Schedule-Management-System
System for HR department to manage interview schedules
<h3>Prerequisites</h3>
i.Visit Google API Console, click Create Project, and follow the wizard to create a new project.<br>
ii.Enable both Gmail and Google Sheets APIs for the project.<br>
iii.Go to Credentials -> OAuth consent screen, enter a product name to be shown to users, and click Save.<br>
iv.On the Credentials tab, click Create credentials and select OAuth client ID.<br>
v.Select an application type, enter a name for the application, and specify a redirect URI (enter https://developers.google.com/oauthplayground if you want to use OAuth 2.0 playground to receive the authorization code and obtain the access token and refresh token).<br>
vi.Click Create. Your client ID and client secret appear.<br>
vii.In a separate browser window or tab, visit OAuth 2.0 playground, select the required Gmail and Google Sheets API scopes, and then click Authorize APIs.<br>
viii.When you receive your authorization code, click Exchange authorization code for tokens to obtain the refresh token and access token.<br>

<h3>Please follow the Steps</h3>
1.Create a Google Sheet as follows from the same Google account you have obtained the client credentials and tokens to access both APIs.Create 2 sheets as shown in the images.<br>

2.Create Twilio Account and get Account SID and AuthToken.<br>
3.add ballerina.config file to the root folder.<br>
![alt text](https://github.com/LakshanSS/Interview-Schedule-Management-System/blob/master/images/config.png)<br>
4.Run the following command in terminal<br>
$ ballerina run notification-sender

