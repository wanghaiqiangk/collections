#!/usr/bin/awk -f

BEGIN {
    if (POLE)
    {
        print "POLE", POLE
        if (POLE == 1)
        {
            action["0.25"] = "enter"
            action["3.40"] = "leave"
        }
        else if (POLE == 2)
        {
            action["0.25"] = "leave"
            action["3.40"] = "enter"
        }
        else
        {
            print "Unknonw POLE"
            exit
        }
    }
    else
    {
        print "No POLE defined"
        exit
    }
}

{
    match($0, /CarId\(\s*([[:digit:]]+)\)/, _id)
    match($0, /plate\(\s*([[:alnum:]]+)\)/, _plate)
    match($0, /color\(\s*([[:digit:]]+)\)/, _color)
    match($0, /special\(\s*([[:digit:]]+)\)/, _ai)
    id = _id[1]
    if (!prev_id || prev_id == id)
    {
        if (_plate[1])
            plate[plate_num++] = _plate[1]
    }
    else
    {
        plate_num = 0
        color = 0
        ai = 0
        delete plate
        if (_plate[1])
            plate[plate_num++] = _plate[1]
    }
    if (_color[1] == 9)
        color++
    if (_ai[1] == 10)
        ai++
    prev_id = id
}

/type\(\s*fire\)/ {
    match($0, /Yaw\(\s*([[:digit:]]*\.?[[:digit:]]+)\s*rad\)/, dir)

    printf "%s %s %d %s pole %d plate ", $1, $2, prev_id, action[dir[1]], POLE

    uniq_plate_num = 0
    delete uniq_plate
    asort(plate)
    for (plt in plate)
    {
        if (plt == 1)
        {
            uniq_plate[uniq_plate_num] = plate[plt]
        }
        if (uniq_plate[uniq_plate_num] != plate[plt])
        {
            uniq_plate[++uniq_plate_num] = plate[plt]
        }
    }
    for (plt in uniq_plate)
    {
        printf "%s ", uniq_plate[plt]
    }
    printf "color %d ai %d\n", color, ai
}
