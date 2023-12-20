export const verificationHTML = (otp) => {
  return `
      <html>
        <head>
          <style>
            body {
              font-family: 'Helvetica Neue', Helvetica, Arial, sans-serif;
              line-height: 1.5;
              background-color: #f4f4f4;
              margin: 0;
              padding: 0;
            }
  
            .header {
              background-color: #006400;
              padding: 20px;
              text-align: center;
            }
  
            .header h1 {
              color: #ffffff;
              margin: 0;
              font-size: 28px;
            }
  
            .content {
              padding: 20px;
              background-color: #ffffff;
            }
  
            .content p {
              margin-bottom: 15px;
              font-size: 18px;
              color: #333333;
            }
  
            .content h3 {
              color: #006400;
              margin: 0 0 10px;
              font-size: 24px;
            }
  
            .footer {
              background-color: #f9f9f9;
              padding: 20px;
              text-align: center;
            }
  
            .footer p {
              margin: 0;
              font-size: 16px;
              color: #888888;
            }
          </style>
        </head>
        <body>
          <div class="header">
            <h1>Exam Preparation Companion Account Verification</h1>
          </div>
  
          <div class="content">
            <p>Hello,</p>
            <p>Thank you for signing up with Exam Preparation Companion. To verify your account and complete the signup process, please use the following verification code:</p>
            <h3>${otp}</h3>
            <p><strong>This verification code is valid for 5 minutes.</strong> Please enter it on the verification page to proceed.</p>
            <p>If you did not sign up for a Exam Preparation Companion account, please ignore this email.</p>
          </div>
  
          <div class="footer">
            <p>Best regards,</p>
            <p>Exam Preparation Companion Team</p>
          </div>
        </body>
      </html>
    `;
};
