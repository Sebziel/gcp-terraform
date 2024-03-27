from faker import Faker
import time

faker = Faker()

def generate_fake_user_data():
    fake_user_data = {
        "first_name": faker.first_name(),
        "last_name": faker.last_name(),
        "email": faker.email(),
        "phone_number": faker.numerify('#########'),
        "id": faker.uuid4()
    }
    return fake_user_data

def generate_multiple_fake_users(user_count, verbose):
    user_list = []
    if verbose:
        started_at = time.monotonic()
        print(f'Generating random user data')

    for item in range(user_count):
        user = generate_fake_user_data()
        user_list.append(user)
    
    if verbose:
        total_time = time.monotonic() - started_at
        print(f'Finished generating random data in {total_time}')
    
    return user_list