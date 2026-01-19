import { initializeApp } from "firebase/app";
import { getAuth, onAuthStateChanged } from "firebase/auth";

// Paste your exact firebaseConfig from your existing code
const firebaseConfig = {
  apiKey: "YOUR_API_KEY",
  authDomain: "YOUR_PROJECT_ID.firebaseapp.com",
  projectId: "YOUR_PROJECT_ID",
  appId: "YOUR_APP_ID",
};

const app = initializeApp(firebaseConfig);
const auth = getAuth(app);

// Listen for current auth state
onAuthStateChanged(auth, (user) => {
  if (user) {
    console.log("✅ User is signed in:", user.email, user.displayName);
  } else {
    console.log("⚠️ No user signed in (Google placeholder blank)");
  }
});
