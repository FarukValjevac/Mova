import React from 'react';

const TermsAndConditions: React.FC = () => {
  return (
    <div style={{ padding: '40px 20px', maxWidth: '800px', margin: '0 auto', fontFamily: 'Arial, sans-serif' }}>
      <h1>Terms and Conditions</h1>
      <p style={{ color: '#666', marginBottom: '30px' }}>
        <em>Last updated: {new Date().toLocaleDateString()}</em>
      </p>
      
      <div style={{ lineHeight: '1.6', color: '#333' }}>
        <h2>1. Acceptance of Terms</h2>
        <p>
          [Placeholder text] By accessing and using the Mova application, you accept and agree to be bound by the terms and provision of this agreement. 
          If you do not agree to abide by the above, please do not use this service.
        </p>

        <h2>2. Use License</h2>
        <p>
          [Placeholder text] Permission is granted to temporarily use Mova for personal, non-commercial transitory viewing only. 
          This is the grant of a license, not a transfer of title.
        </p>

        <h2>3. User Account</h2>
        <p>
          [Placeholder text] When you create an account with us, you must provide information that is accurate, complete, and current at all times. 
          You are responsible for safeguarding the password and all activities that occur under your account.
        </p>

        <h2>4. Privacy Policy</h2>
        <p>
          [Placeholder text] Your privacy is important to us. Please review our Privacy Policy, which also governs your use of the Service, 
          to understand our practices.
        </p>

        <h2>5. Prohibited Uses</h2>
        <p>
          [Placeholder text] You may not use our service for any illegal or unauthorized purpose nor may you, 
          in the use of the service, violate any laws in your jurisdiction.
        </p>

        <h2>6. Disclaimer</h2>
        <p>
          [Placeholder text] The information on this application is provided on an "as is" basis. To the fullest extent permitted by law, 
          this Company excludes all representations, warranties, conditions and terms.
        </p>

        <h2>7. Contact Information</h2>
        <p>
          [Placeholder text] If you have any questions about these Terms and Conditions, please contact us at: 
          <br />
          Email: legal@mova.app
          <br />
          Address: [Company Address to be added]
        </p>
      </div>

      <div style={{ marginTop: '40px', padding: '20px', backgroundColor: '#f5f5f5', borderRadius: '5px' }}>
        <h3>Note:</h3>
        <p style={{ margin: '0', color: '#666', fontStyle: 'italic' }}>
          This is a placeholder Terms and Conditions page. The actual legal terms will be added later by the legal team.
        </p>
      </div>
    </div>
  );
};

export default TermsAndConditions;