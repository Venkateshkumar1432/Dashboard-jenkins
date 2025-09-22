FROM node:20-alpine

WORKDIR /app

# Copy package files
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy source code
COPY . .

# Generate Prisma client if prisma exists
RUN if [ -f "prisma/schema.prisma" ]; then npx prisma generate; fi

# Expose port
EXPOSE 4005

# Run migrations and start the application
CMD ["sh", "-c", "npx prisma migrate deploy && npx prisma db seed && npm run dev"]