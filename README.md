# XKSoft Service Desk

## Live Demo
Check out the live demo of the service desk here: [XKSoft Service Desk Live](https://xksoft.westus2.azurecontainer.io/auth/login.asp)

## Overview
XKSoft Service Desk is a classic ASP-based application designed for AJAX SQL Server authentication for users. It integrates advanced security measures like CSRF tokens, authentication tokens, and parameterized queries to ensure robust, secure operations.

## Features
- **Classic ASP with AJAX**: Uses Classic ASP technology combined with AJAX for responsive user interactions.
- **Robust Security Features**:
  - Security headers, CSRF tokens, and authentication tokens for secure logins.
  - Parameterized queries and thorough input validation to prevent SQL Injection and other vulnerabilities.
- **Integration with ASP.NET API**: Connects to a backend ASP.NET API for ticket management, configured to allow CORS from the website only.
- **Environment Configuration**: Utilizes environment variables for secure configuration management.
- **User-Friendly UI**: Desktop-optimized interface for managing tickets. (Note: Mobile compatibility is not supported.)

## Prerequisites
- IIS configured for Classic ASP.
- Microsoft SQL Server.
- Docker (optional, for building containerized environments).

## Installation

### Local Setup
For development purposes, the following setup is recommended:

1. **Environment Variables**:
   In a production environment, ensure the following environment variables are set:
   - `DB_CONNECTION_STRING`: Connection string for SQL Server.
   - `API_BASE_URL`: URL of the ASP.NET API.
   
   For local development, you can directly set these within your Classic ASP files:
   ```asp
   Session("DBConnectionString") = "yourDevConnectionStringHere"
   Session("APIBaseUrl") = "yourDevApiBaseUrlHere"

### Using Docker

To build and run the Classic ASP section using Docker, follow these steps:

    Build the Docker Image:
    Navigate to the directory containing your Dockerfile and run:

    docker build -t xksoftservicedesk .


Run the Container:

    docker run -p 80:80 443:443 xksoftservicedesk

    Ensure you have configured the necessary environment variables for your container.

    Note: If deploying to a production environment, replace localhost in the Dockerfile with your production domain to configure SSL properly. Ensure HTTPS is enabled to meet the requirements of SSL certificate generation tools like win-acme.

### HTTPS and SSL Certificate Configuration

For production environments requiring secure HTTPS connections, it is necessary to configure SSL certificates:

    Using win-acme for SSL: If using win-acme on a Windows server, ensure your production domain is properly pointed at your server and that IIS is configured to serve your site over HTTPS.
    Modify Production URL: Change the production URL in the Dockerfile from localhost to your actual domain before building the image for production use.

Usage

Access the XKSoft Service Desk through a web browser by navigating to the hosted URL. Authenticate using your user credentials to manage tickets.
Known Issues

    UI does not support mobile devices and may not render correctly on screens smaller than desktop monitors.

Credits and Acknowledgments

    Password hashing functionality adapted from ClassicASP.PasswordHashing.
    Dual-range slider implementation inspired by a Medium article by Predrag Davidovic.
