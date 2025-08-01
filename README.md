# httphost.dev

## Bootstrap your Amazon Web Services account

Before you can deploy any hosting infrastructure to your Amazon Web Services account, you must bootstrap it.

As a powerful user, manually:

1. Deploy [cloudformation/account-bootstrap.cf.yaml](cloudformation/account-bootstrap.cf.yaml) with the stack name `httphostdev-bootstrap`.
1. Attach the Managed Policy `httphost.dev-ManageWebsiteInfrastructure-{REGION}` to roles and users that need to deploy hosting infrastructure.

## Deploying a new website

### Bootstrapping the infrastructure

As any role or user with permission to manage website infrastructure, run:

```bash
./scripts/deploy-website-bootstrap.sh <DOMAIN>
```

For example:

```bash
./scripts/deploy-website-bootstrap.sh example.com
```

The script will print a list of name servers which you must apply to the domain in your registrar. The script cannot do this for you.

When the name servers have been applied to your domain, run:

```bash
./scripts/deploy-website-infrastructure.sh <DOMAIN>
```

### Publishing content

TODO
