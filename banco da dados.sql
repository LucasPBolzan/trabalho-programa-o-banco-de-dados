
CREATE TABLE CarModels (
    id SERIAL PRIMARY KEY,
    brand VARCHAR(50) NOT NULL,
    model VARCHAR(50) NOT NULL,
    capacity INTEGER NOT NULL
);

CREATE TABLE Cars (
    id SERIAL PRIMARY KEY,
    model_id INTEGER REFERENCES CarModels(id),
    year INTEGER NOT NULL,
    plate VARCHAR(10) UNIQUE NOT NULL,
    status VARCHAR(20) NOT NULL 
);

CREATE TABLE Customers (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    phone VARCHAR(15),
    email VARCHAR(100) UNIQUE
);

CREATE TABLE Reservations (
    id SERIAL PRIMARY KEY,
    car_id INTEGER REFERENCES Cars(id),
    customer_id INTEGER REFERENCES Customers(id),
    pickup_date DATE NOT NULL,
    return_date DATE NOT NULL
);

select * from cars where status = 'alugado'


