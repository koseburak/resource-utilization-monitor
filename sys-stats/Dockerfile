FROM node:14.18-alpine AS base

LABEL maintainer="Burak KOSE<burakkose86@gmail.com>" version="0.0.1"

# Set non-root User Name and Home Directory
ENV APP_USER=observer
ENV APP_HOME=/home/$APP_USER

# Install sudo
RUN apk add --update sudo

# Add new user
RUN adduser -D $APP_USER \
        && echo "$APP_USER ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/$APP_USER \
        && chmod 0440 /etc/sudoers.d/$APP_USER

# Set Working Directory 
WORKDIR $APP_HOME

# Prepare the runtime Image
FROM base

ENV CHOKIDAR_USEPOLLING=true

# Copy source files
COPY . .

# Change owner as a $APP_USER
RUN chown -R $APP_USER:$APP_USER $APP_HOME

# Switch to APP USER
USER $APP_USER

# Install node modules
RUN npm install

# Create VOLUME for node_modules
VOLUME /$APP_USER/node_modules

CMD ["npm", "run", "start"]