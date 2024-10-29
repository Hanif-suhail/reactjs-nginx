# Stage 1: Build the React app
FROM node:alpine AS build
WORKDIR /app

# Copy only package.json and package-lock.json
COPY package*.json ./

ENV NODE_OPTIONS="--no-warnings"

# Install only production dependencies
RUN npm install --omit=dev --verbose

# Copy the rest of the application code
COPY . .

# Build the app
RUN npm run build

# Stage 2: Serve the app with Nginx
FROM nginx:alpine
RUN rm -rf /usr/share/nginx/html/*

# Copy the built React app from the previous stage
COPY --from=build /app/build /usr/share/nginx/html
#-g will help to add more config to overwrite default config; deamon off will ennsure nginx run on the backgraound
EXPOSE 80
CMD [ "nginx", "-g", "daemon off;" ]
