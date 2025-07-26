import React from 'react';

const PrivacyPolicy: React.FC = () => {
  return (
    <div style={{ padding: '40px 20px', maxWidth: '800px', margin: '0 auto', fontFamily: 'Arial, sans-serif' }}>
      <h1>Privacy Policy</h1>
      <p style={{ color: '#666', marginBottom: '30px' }}>
        <em>Last updated: {new Date().toLocaleDateString()}</em>
      </p>
      
      <div style={{ lineHeight: '1.6', color: '#333' }}>
        <h2>1. Information We Collect</h2>
        <p>
          [Placeholder text] We collect information you provide directly to us, such as when you create an account, 
          subscribe to our newsletter, or contact us for support. This may include your name, email address, phone number, and company information.
        </p>

        <h2>2. How We Use Your Information</h2>
        <p>
          [Placeholder text] We use the information we collect to provide, maintain, and improve our services, 
          process transactions, send you technical notices and support messages, and communicate with you about products and services.
        </p>

        <h2>3. Information Sharing</h2>
        <p>
          [Placeholder text] We do not sell, trade, or otherwise transfer your personal information to third parties without your consent, 
          except as described in this policy. We may share your information in certain limited circumstances.
        </p>

        <h2>4. Data Security</h2>
        <p>
          [Placeholder text] We implement appropriate technical and organizational measures to protect your personal information 
          against unauthorized access, alteration, disclosure, or destruction.
        </p>

        <h2>5. Data Retention</h2>
        <p>
          [Placeholder text] We retain your personal information for as long as necessary to provide you with our services 
          and for legitimate business purposes, such as maintaining performance, analyzing usage, and legal obligations.
        </p>

        <h2>6. Your Rights</h2>
        <p>
          [Placeholder text] You have certain rights regarding your personal information, including the right to access, 
          update, or delete your information. You may also opt out of certain communications from us.
        </p>

        <h2>7. Cookies and Tracking</h2>
        <p>
          [Placeholder text] We use cookies and similar tracking technologies to collect information about your browsing activities 
          and to provide you with a personalized experience.
        </p>

        <h2>8. Changes to This Policy</h2>
        <p>
          [Placeholder text] We may update this Privacy Policy from time to time. We will notify you of any changes 
          by posting the new Privacy Policy on this page and updating the "Last updated" date.
        </p>

        <h2>9. Contact Us</h2>
        <p>
          [Placeholder text] If you have any questions about this Privacy Policy, please contact us at:
          <br />
          Email: privacy@mova.app
          <br />
          Address: [Company Address to be added]
        </p>
      </div>

      <div style={{ marginTop: '40px', padding: '20px', backgroundColor: '#f5f5f5', borderRadius: '5px' }}>
        <h3>Note:</h3>
        <p style={{ margin: '0', color: '#666', fontStyle: 'italic' }}>
          This is a placeholder Privacy Policy. The actual privacy policy will be crafted by our legal team 
          to ensure compliance with all applicable privacy laws and regulations.
        </p>
      </div>
    </div>
  );
};

export default PrivacyPolicy;