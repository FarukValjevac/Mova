import React, { useState } from 'react';
import { EarlyBirdSignup, ApiResponse } from '../types/api';
import TermsAndConditions from './TermsAndConditions';
import PrivacyPolicy from './PrivacyPolicy';

interface FormData extends EarlyBirdSignup {
  termsAccepted: boolean;
}

const EarlyBirdForm: React.FC = () => {
  const [formData, setFormData] = useState<FormData>({
    name: '',
    email: '',
    phone: '',
    company: '',
    termsAccepted: false,
  });
  const [isSubmitting, setIsSubmitting] = useState(false);
  const [message, setMessage] = useState<{ type: 'success' | 'error'; text: string } | null>(null);
  const [modalContent, setModalContent] = useState<'terms' | 'privacy' | null>(null);

  const handleChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    const { name, value, type, checked } = e.target;
    setFormData(prev => ({
      ...prev,
      [name]: type === 'checkbox' ? checked : value,
    }));
  };

  const openModal = (content: 'terms' | 'privacy') => {
    setModalContent(content);
  };

  const closeModal = () => {
    setModalContent(null);
  };

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    setIsSubmitting(true);
    setMessage(null);

    try {
      const response = await fetch('http://localhost:3000/early-bird/signup', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify(formData),
      });

      const result: ApiResponse = await response.json();

      if (result.success) {
        setMessage({ type: 'success', text: result.message });
        setFormData({ name: '', email: '', phone: '', company: '', termsAccepted: false });
      } else {
        setMessage({ type: 'error', text: result.message });
      }
    } catch (error) {
      setMessage({ type: 'error', text: 'Network error. Please try again.' });
    } finally {
      setIsSubmitting(false);
    }
  };

  return (
    <div className="early-bird-form">
      <h3>Get Early Access</h3>
      <p>Be the first to know when Mova launches</p>
      
      {message && (
        <div className={`message ${message.type}`}>
          {message.text}
        </div>
      )}

      <form onSubmit={handleSubmit}>
        <div className="form-group">
          <input
            type="text"
            name="name"
            placeholder="Full Name *"
            value={formData.name}
            onChange={handleChange}
            required
          />
        </div>
        
        <div className="form-group">
          <input
            type="email"
            name="email"
            placeholder="Email Address *"
            value={formData.email}
            onChange={handleChange}
            required
          />
        </div>
        
        <div className="form-group">
          <input
            type="tel"
            name="phone"
            placeholder="Phone Number (Optional)"
            value={formData.phone}
            onChange={handleChange}
          />
        </div>
        
        <div className="form-group">
          <input
            type="text"
            name="company"
            placeholder="Company (Optional)"
            value={formData.company}
            onChange={handleChange}
          />
        </div>
        
        <div className="form-group checkbox-group" style={{ marginTop: '16px', marginBottom: '16px', textAlign: 'center' }}>
          <label className="checkbox-label" style={{ 
            cursor: 'pointer',
            fontSize: '14px',
            color: '#555',
            lineHeight: '1.4'
          }}>
            <input
              type="checkbox"
              name="termsAccepted"
              checked={formData.termsAccepted}
              onChange={handleChange}
              required
              style={{ 
                marginRight: '8px',
                verticalAlign: 'middle'
              }}
            />
            I agree to the{' '}
            <button 
              type="button" 
              onClick={() => openModal('terms')} 
              style={{ 
                background: 'none', 
                border: 'none', 
                color: '#007bff', 
                textDecoration: 'underline', 
                cursor: 'pointer', 
                padding: '0', 
                font: 'inherit',
                fontSize: '14px',
                outline: 'none',
                transform: 'none',
                transition: 'none'
              }}
            >
              Terms and Conditions
            </button>{' '}
            and{' '}
            <button 
              type="button" 
              onClick={() => openModal('privacy')} 
              style={{ 
                background: 'none', 
                border: 'none', 
                color: '#007bff', 
                textDecoration: 'underline', 
                cursor: 'pointer', 
                padding: '0', 
                font: 'inherit',
                fontSize: '14px',
                outline: 'none',
                transform: 'none',
                transition: 'none'
              }}
            >
              Privacy Policy
            </button>
          </label>
        </div>
        
        <button type="submit" disabled={isSubmitting || !formData.termsAccepted}>
          {isSubmitting ? 'Submitting...' : 'Join Early Bird List'}
        </button>
      </form>

      {/* Modal for Terms and Privacy Policy */}
      {modalContent && (
        <div style={{
          position: 'fixed',
          top: 0,
          left: 0,
          right: 0,
          bottom: 0,
          backgroundColor: 'rgba(0, 0, 0, 0.5)',
          display: 'flex',
          alignItems: 'center',
          justifyContent: 'center',
          zIndex: 1000,
          padding: '20px'
        }} onClick={closeModal}>
          <div style={{
            backgroundColor: 'white',
            borderRadius: '8px',
            maxWidth: '900px',
            maxHeight: '80vh',
            overflow: 'auto',
            position: 'relative'
          }} onClick={(e) => e.stopPropagation()}>
            <button
              onClick={closeModal}
              style={{
                position: 'absolute',
                top: '15px',
                right: '15px',
                background: 'none',
                border: 'none',
                fontSize: '24px',
                cursor: 'pointer',
                zIndex: 1,
                color: '#666'
              }}
            >
              ×
            </button>
            {modalContent === 'terms' ? <TermsAndConditions /> : <PrivacyPolicy />}
          </div>
        </div>
      )}
    </div>
  );
};

export default EarlyBirdForm;