# s3-website
builds a s3 website with cloudfront  using cloudposse aws-cloudfront-s3-cdn
you will first need to run the command below to generate the ACM cert via the cli 

### Generating ACM Certificate

Use the AWS cli to [request new ACM certifiates](http://docs.aws.amazon.com/acm/latest/userguide/gs-acm-request.html) (requires email validation)
```
aws acm request-certificate --domain-name example.com --subject-alternative-names a.example.com b.example.com *.c.example.com
```

#### yoou will need to set up github vars 

Creating encrypted secrets for a repository
To create secrets for a user account repository, you must be the repository owner. To create secrets for an organization repository, you must have admin access.

On GitHub, navigate to the main page of the repository.
Under your repository name, click  Settings.
Repository settings button
In the left sidebar, click Secrets.
Click New repository secret.
Type a name for your secret in the Name input box.
Enter the value for your secret.
Click Add secret.
If your repository has environment secrets or can access secrets from the parent organization, then those secrets are also listed on this page.

Creating encrypted secrets for an environment
To create secrets for an environment in a user account repository, you must be the repository owner. To create secrets for an environment in an organization repository, you must have admin access.

On GitHub, navigate to the main page of the repository.
Under your repository name, click  Settings.
Repository settings button
In the left sidebar, click Environments.
Click on the environment that you want to add a secret to.
Under Environment secrets, click Add secret.
Type a name for your secret in the Name input box.
Enter the value for your secret.
Click Add secret.
Creating encrypted secrets for an organization
When creating a secret in an organization, you can use a policy to limit which repositories can access that secret. For example, you can grant access to all repositories, or limit access to only private repositories or a specified list of repositories.

To create secrets at the organization level, you must have admin access.

On GitHub, navigate to the main page of the organization.
Under your organization name, click  Settings.
Organization settings button
In the left sidebar, click Secrets.
Click New organization secret.
Type a name for your secret in the Name input box.
Enter the Value for your secret.
From the Repository access dropdown list, choose an access policy.
Click Add secret.
Reviewing access to organization-level secrets
You can check which access policies are being applied to a secret in your organization.

On GitHub, navigate to the main page of the organization.
Under your organization name, click  Settings.
Organization settings button
In the left sidebar, click Secrets.
The list of secrets includes any configured permissions and policies. For example:
Secrets list
For more details on the configured permissions for each secret, click Update.
Using encrypted secrets in a workflow
With the exception of GITHUB_TOKEN, secrets are not passed to the runner when a workflow is triggered from a forked repository.

To provide an action with a secret as an input or environment variable, you can use the secrets context to access secrets you've created in your repository. For more information, see "Context and expression syntax for GitHub Actions" and "Workflow syntax for GitHub Actions."

steps:
  - name: Hello world action
    with: # Set the secret as an input
      super_secret: ${{ secrets.SuperSecret }}
    env: # Or as an environment variable
      super_secret: ${{ secrets.SuperSecret }}
Avoid passing secrets between processes from the command line, whenever possible. Command-line processes may be visible to other users (using the ps command) or captured by security audit events. To help protect secrets, consider using environment variables, STDIN, or other mechanisms supported by the target process.

If you must pass secrets within a command line, then enclose them within the proper quoting rules. Secrets often contain special characters that may unintentionally affect your shell. To escape these special characters, use quoting with your environment variables. For example:

Example using Bash
steps:
  - shell: bash
    env:
      SUPER_SECRET: ${{ secrets.SuperSecret }}
    run: |
      example-command "$SUPER_SECRET"
Example using PowerShell
steps:
  - shell: pwsh
    env:
      SUPER_SECRET: ${{ secrets.SuperSecret }}
    run: |
      example-command "$env:SUPER_SECRET"
Example using Cmd.exe
steps:
  - shell: cmd
    env:
      SUPER_SECRET: ${{ secrets.SuperSecret }}
    run: |
      example-command "%SUPER_SECRET%"
Limits for secrets
You can store up to 1,000 secrets per organization, 100 secrets per repository, and 100 secrets per environment. A workflow may use up to 100 organization secrets and 100 repository secrets. Additionally, a job referencing an environment may use up to 100 environment secrets.

Secrets are limited to 64 KB in size. To use secrets that are larger than 64 KB, you can store encrypted secrets in your repository and save the decryption passphrase as a secret on GitHub. For example, you can use gpg to encrypt your credentials locally before checking the file in to your repository on GitHub. For more information, see the "gpg manpage."

Warning: Be careful that your secrets do not get printed when your action runs. When using this workaround, GitHub does not redact secrets that are printed in logs.

Run the following command from your terminal to encrypt the my_secret.json file using gpg and the AES256 cipher algorithm.

$ gpg --symmetric --cipher-algo AES256 my_secret.json
You will be prompted to enter a passphrase. Remember the passphrase, because you'll need to create a new secret on GitHub that uses the passphrase as the value.

Create a new secret that contains the passphrase. For example, create a new secret with the name LARGE_SECRET_PASSPHRASE and set the value of the secret to the passphrase you selected in the step above.

Copy your encrypted file into your repository and commit it. In this example, the encrypted file is my_secret.json.gpg.

Create a shell script to decrypt the password. Save this file as decrypt_secret.sh.

#!/bin/sh

# Decrypt the file
mkdir $HOME/secrets
# --batch to prevent interactive command
# --yes to assume "yes" for questions
gpg --quiet --batch --yes --decrypt --passphrase="$LARGE_SECRET_PASSPHRASE" \
--output $HOME/secrets/my_secret.json my_secret.json.gpg
Ensure your shell script is executable before checking it in to your repository.

$ chmod +x decrypt_secret.sh
$ git add decrypt_secret.sh
$ git commit -m "Add new decryption script"
$ git push
From your workflow, use a step to call the shell script and decrypt the secret. To have a copy of your repository in the environment that your workflow runs in, you'll need to use the actions/checkout action. Reference your shell script using the run command relative to the root of your repository.

name: Workflows with large secrets

on: push

jobs:
  my-job:
    name: My Job
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - name: Decrypt large secret
        run: ./.github/scripts/decrypt_secret.sh
        env:
          LARGE_SECRET_PASSPHRASE: ${{ secrets.LARGE_SECRET_PASSPHRASE }}
      # This command is just an example to show your secret being printed
      # Ensure you remove any print statements of your secrets. GitHub does
      # not hide secrets that use this workaround.
      - name: Test printing your secret (Remove this step in production)
        run: cat $HOME/secrets/my_secret.json
