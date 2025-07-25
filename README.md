# Mova - Coming Soon Landing Page

Beautiful landing page with early bird signup form. No technical skills required!

## 🚀 Quick Start for Beginners

### Step 1: Get the Code

1. Download this project (click green "Code" button → "Download ZIP")
2. Extract the ZIP file to your Desktop
3. Open Terminal (Mac) or Command Prompt (Windows)

### Step 2: Navigate to Project

```bash
# Mac/Linux - Type this in Terminal:
cd Desktop/mova-main

# Windows - Type this in Command Prompt:
cd Desktop\mova-main
```

### Step 3: Configure Email (Important!)

1. The script creates a file called `backend/.env`
2. Edit it and add your Gmail credentials:
   ```
   EMAIL_USER=your-email@gmail.com
   EMAIL_PASS=your-app-password
   ```
3. **Important:** Use Gmail App Password, not regular password!

### Step 4: Run the Magic Script

**Mac/Linux:**

```bash
chmod +x start-app.sh
./start-app.sh install
./start-app.sh run
```

**Windows:**

```cmd
start-app.bat install
start-app.bat run
```

### Step 5: Done! 🎉

- Your website opens automatically at http://localhost:3001
- Press **Ctrl+C** to stop the servers

## What Does This Do?

- Installs everything needed
- Starts your landing page website
- Collects early bird signups via email
- Works on any computer, no coding knowledge needed

## Need Help?

The install script guides you through everything automatically. Just follow the on-screen instructions!

## Email Configuration

After running the install command, you need to configure your Gmail credentials:

1. Edit `backend/.env` file
2. Add your Gmail credentials:
   ```env
   EMAIL_USER=your-email@gmail.com
   EMAIL_PASS=your-app-password
   ```

**For Gmail users:**

1. Enable 2-factor authentication on your Google account
2. Generate an App Password (not your regular password)
3. Use the App Password in the EMAIL_PASS field

## Manual Setup Instructions (Advanced Users)

### Prerequisites

- Node.js 18+ installed
- npm or yarn package manager

### Installation

**Backend:**

```bash
cd backend
npm install
```

**Frontend:**

```bash
cd frontend
npm install
```

### Development

**Backend (http://localhost:3000):**

```bash
cd backend
npm run dev
```

**Frontend (http://localhost:3001):**

```bash
cd frontend
npm run dev
```

### Production Build

**Build backend:**

```bash
cd backend
npm run build
```

**Build frontend:**

```bash
cd frontend
npm run build
```

**Start production server:**

```bash
cd backend
npm start
```

## API Endpoints

- `POST /early-bird/signup` - Submit early bird signup

### Request Body:

```json
{
  "name": "John Doe",
  "email": "john@example.com",
  "phone": "+1234567890", // optional
  "company": "Acme Corp" // optional
}
```

## Project Structure

```
backend/
└── src/
    ├── early-bird/
    │   ├── dto/
    │   │   └── create-early-bird.dto.ts    # Validation DTOs
    │   ├── interfaces/
    │   │   └── early-bird.interface.ts     # TypeScript interfaces
    │   ├── early-bird.controller.ts        # REST controller
    │   ├── early-bird.service.ts           # Business logic
    │   └── early-bird.module.ts            # NestJS module
    ├── app.module.ts                       # Main app module
    └── main.ts                             # Application entry point

frontend/
├── src/
│   ├── components/
│   │   └── EarlyBirdForm.tsx           # Signup form component
│   ├── types/
│   │   └── api.ts                      # TypeScript types
│   ├── App.tsx                         # Main app component
│   └── main.tsx                        # Frontend entry point
└── index.html                          # HTML template
```

## Technologies Used

**Backend:**

- NestJS
- TypeScript
- class-validator
- class-transformer
- Nodemailer

**Frontend:**

- React
- TypeScript
- Vite
- Modern CSS with gradients and animations

## Troubleshooting

### Node.js Not Found

- **Mac/Linux**: The script will attempt to install Node.js via Homebrew (Mac) or package manager (Linux)
- **Windows**: Visit https://nodejs.org/ to download and install Node.js manually

### Email Authentication Error

- Make sure you're using an App Password, not your regular Gmail password
- Ensure 2-factor authentication is enabled on your Google account
- Check that the credentials in `backend/.env` are correct

### Port Already in Use

- Stop any other applications running on ports 3000 or 3001
- Use `./start-app.sh stop` or `start-app.bat stop` to stop the servers

### Clean Start

If you encounter any issues, try a clean installation:

```bash
# Mac/Linux
./start-app.sh clean
./start-app.sh install

# Windows
start-app.bat clean
start-app.bat install
```

## Contributing

1. Fork the repository
2. Create your feature branch
3. Commit your changes
4. Push to the branch
5. Create a Pull Request

## License

This project is licensed under the ISC License.
