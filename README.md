# Mova Landing Page 🚀

Hey noob! 👋 Don't worry, I made this dummy-proof for you.

## For Complete Computer Illiterates (Yes, That's You)

### Step 1: Download This Thing
1. Click the green "Code" button → "Download ZIP" (you know what a ZIP file is, right?)
2. Extract it to your Desktop (double-click the ZIP, genius)
3. Open Terminal (Mac) or Command Prompt (Windows) - Google it if you don't know how

### Step 2: Navigate Like a Pro Hacker 😎
```bash
# Mac users - type this, you noob:
cd Desktop/mova-main

# Windows peasants - type this instead:
cd Desktop\mova-main
```

### Step 3: The Magic Happens (Install Everything)

**Mac users:**
```bash
./start-app.sh install
```

**Windows users:**
```cmd
start-app.bat install
```

*If it says "permission denied" or some scary error, just restart Terminal and try again, dummy.*

### Step 4: Email Setup (Don't Mess This Up)
1. Find the file `backend/.env` (it's inside the backend folder, duh)
2. Edit it with your Gmail info:
   ```
   EMAIL_USER=your-email@gmail.com
   EMAIL_PASS=your-app-password
   ```
3. **IMPORTANT**: Use Gmail App Password, not your regular password! (Google "gmail app password" if you're confused)

### Step 5: Launch Your Website Like a Boss
**Mac:**
```bash
./start-app.sh run
```

**Windows:**
```cmd
start-app.bat run
```

### Step 6: Victory! 🎉
- Your website opens at http://localhost:3001 (it should open automatically, but click the link if you're lost)
- Press **Ctrl+C** to stop everything (when you're done showing off)

## What This Actually Does
- Creates a professional landing page for your Mova project
- Collects email signups from early birds
- Sends you notifications when someone signs up
- Makes you look like you know what you're doing

## When Things Go Wrong (They Will)
- **"Command not found"**: You probably didn't install Node.js. The script will try to help you, but you might need to visit https://nodejs.org/
- **Email not working**: You messed up the Gmail setup. Read Step 4 again, carefully.
- **Port errors**: Something else is using the same ports. Restart your computer (the classic IT solution).

## Need Help?
Ask someone who knows computers. Or Google it. But honestly, if you can't follow these 6 steps, maybe stick to using Word. 😉

*PS: You're welcome for making this so simple even your grandma could do it.*
