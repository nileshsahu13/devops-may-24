# ---------- Stage 1: Build Stage ----------
FROM node:18-alpine as builder

# Set working directory
WORKDIR /app

# Copy package files and install dependencies (including dev dependencies)
COPY package*.json ./
RUN npm install

# Copy the rest of the application code
COPY . .

# Optional: Run build step (for TypeScript, Webpack, etc.)
# RUN npm run build


# ---------- Stage 2: Production Stage ----------
FROM node:18-alpine

# Set working directory
WORKDIR /app

# Copy only needed files from the builder stage
COPY --from=builder /app/package*.json ./
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/dist ./dist  # If your build output is in `dist`
COPY --from=builder /app/index.js ./index.js  # Adjust as needed

# Set NODE_ENV to production
ENV NODE_ENV=production

# Expose application port
EXPOSE 3000

# Start the app
CMD ["node", "index.js"]
