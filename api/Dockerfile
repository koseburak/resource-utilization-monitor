FROM python:3.9 AS base

LABEL maintainer="Burak KOSE<burakkose86@gmail.com>" version="0.0.1"

# Set TimeZone
ENV TZ 'Europe/Istanbul'

# Set non-root User Name and Home Directory
ENV APP_USER=observer
ENV APP_HOME=/home/$APP_USER

# Create non-root User and Group
RUN groupadd -r $APP_USER && \
    useradd -r -g $APP_USER -d $APP_HOME -s /sbin/nologin -c "Application User" $APP_USER

# Set Working Directory 
WORKDIR $APP_HOME

# Set the TimeZone on the OS
RUN echo $TZ > /etc/timezone && apt-get update && \
    apt-get install -y tzdata && \
    rm /etc/localtime && \
    ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && \
    dpkg-reconfigure -f noninteractive tzdata && \
    apt-get clean

# Upgrade pip version
RUN pip install --upgrade pip

# Prepare the runtime Image
FROM base

ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1
ENV PATH="/home/$APP_USER/.local/bin:${PATH}"

# Copy source files
COPY requirements.txt .
COPY app.py .

# Change owner as a $APP_USER
RUN chown -R $APP_USER:$APP_USER $APP_HOME

# Switch to APP USER
USER $APP_USER

# Install requirements
RUN pip install --user --no-cache-dir -r requirements.txt

# Expose the container running port
EXPOSE 5000

# Run flask restapi
CMD ["python3", "-m", "flask", "run", "--host=0.0.0.0"]