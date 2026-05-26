
-record(info, {city, occupation}).
-record(person,
    {name, 
    age = 0,
    info = #info{}
    }).