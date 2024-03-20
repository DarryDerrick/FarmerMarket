import { defineConfig } from 'vite';
import reactRefresh from '@vitejs/plugin-react-refresh';
import { resolve } from 'path';
import dotenv from 'dotenv';

// Load environment variables from .env files
dotenv.config();

// Define the Vite configuration
export default defineConfig({
  plugins: [reactRefresh()],
  resolve: {
    alias: {
      '@': resolve(__dirname, 'src')
    }
  },
  define: {
    // Pass environment variables to the application
    'import.meta.env': {
      VITE_BACKEND_URL: JSON.stringify(process.env.VITE_BACKEND_URL),
      VITE_INTERNET_IDENTITY_URL: JSON.stringify(process.env.VITE_INTERNET_IDENTITY_URL)
    }
  },
  esbuild: {
    // Set the loader for HTML files to 'jsx' to enable JSX syntax parsing
    loader: {
      '.html': 'jsx'
    }
  }
});
