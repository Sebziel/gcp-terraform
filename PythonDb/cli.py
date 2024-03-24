import click
from .DbConnection import create_persons, add_users_to_db


@click.command()
@click.option("--users", "-u", default=10, help="Number of users to create")
@click.option("--verbose", "-v", default=False, help="Printing additional things")
def cli(users, verbose):
    if verbose:
        print( f"Starting to create {users} users")
        add_users_to_db(create_persons(users, verbose), verbose)
    else:
        print("running non-verbose mode")
        add_users_to_db(create_persons(users, verbose), verbose)

if __name__ == '__main__':
    cli()