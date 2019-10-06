# Glossary of Terms

## Infrastructure Controller

Conceptually, the Infrastructure Controller manages the following aspects of
the cloud platform.  There is one Infrastructure Controller per Environment.

 1. Shared VPC Network
 2. Organization Policies
 3. Cross-functional IAM Policies
 4. Service projects

Once a service project is created for an application team, control is
transferred to the Project Controller executing within the service project.

Centralized IT, SRE, DevOps, Networking, and Security teams typically interact
with the Infrastructure Controller to setup infrastructure for development
teams.

The Infrastructure Controller is implemented as a CI/CD runner with a service
account possessing elevated permissions to create the infrastructure within the
environment.

## Project Controller

The Project Controller manages resources within a single project and a single
Environment.  A development team interacts with the project controller.

The Project Controller is implemented as a CI/CD runner with a service account
possessing limited permissions to manage cloud resources within the project.

## Environment

Changes to the infrastructure are deployed into an environment.  There are
typically two environments for the foundational infrastructure, prod and
nonprod.

Environments serve to reduce risk in production.  Changes may be developed,
tested, and iterated in nonprod.  When they're ready, they may be deployed to
production.

