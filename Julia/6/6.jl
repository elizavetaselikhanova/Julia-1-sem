#Задача 6. Робот в проивзольной клетке ограниченного прямоугольного поля, на котором могут находиться также внутренние прямоугольные перегородки.
#Итог: Робот в исходном положении и - а) по всему периметру внешней рамки стоят маркеры.
# б) маркеры не во всех клетках периметра, а только в 4-х позицмях - напротив исходного положения робота.

#Ввести в терминал:
#julia
#using HorizonSideRobots
#include("6.jl")

#mutable struct Coordinates
#    x::Int
#   y::Int
#end
#Coordinates() = Coordinates(0,0)

#function HorizonSideRobots.move!(coord::Coordinates, side::HorizonSide)
#    if side==Nord
#        coord.y += 1
#   elseif side==Sud
#        coord.y -= 1
#    elseif side==Ost
#        coord.x += 1
#    else 
#        coord.x -= 1
#    end
#end

#get_coord(coord::Coordinates) = (coord.x, coord.y)

#struct CoordRobot
#    robot::Robot
#    coord::Coordinates
#end

#CoordRobot(robot) = CoordRobot(robot, Coordinates()) 

#function HorizonSideRobots.move!(robot::CoordRobot, side)
#    move!(robot.robot, side)
#    move!(robot.coord, side)
#end
#HorizonSideRobots.isborder(robot::CoordRobot, side) = isborder(robot.robot, side)
#HorizonSideRobots.putmarker!(robot::CoordRobot) = putmarker!(robot.robot)
#HorizonSideRobots.ismarker(robot::CoordRobot) = ismarker(robot.robot)
#HorizonSideRobots.temperature(robot::CoordRobot) = temperature(robot.robot)

#get_coord(robot::CoordRobot) = get_coord(robot.coord)

#function HorizonSideRobots.move!(robot::CoordRobot, side)
#   move!(robot.robot, side)
#   move!(robot.coord, side)
#end
#HorizonSideRobots.isborder(robot::CoordRobot, side) = isborder(robot.robot, side)
#HorizonSideRobots.putmarker!(robot::CoordRobot) = putmarker!(robot.robot)
#HorizonSideRobots.ismarker(robot::CoordRobot) = ismarker(robot.robot)
#HorizonSideRobots.temperature(robot::CoordRobot) = temperature(robot.robot)

#get_coord(robot::CoordRobot) = get_coord(robot.coord)

#r=CoordRobot(Robot("6.sit",animate=true), Coordinates(0,0))

#solve_1!(r)
#solve_2!(r)

function perimetr_1!(robot) #Функция, ставящая маркеры по периметру 
    for side in(Nord,Ost,Sud,West)
        while (!isborder(robot,side))
            move!(robot,side)
            putmarker!(robot)
        end
    end
end

function perimetr_2!(robot) #Функция, ставящая маркеры по определенным координатам
    for side in(Nord,Ost,Sud,West)
        while (!isborder(robot,side))
            move!(robot,side)
            x,y=get_coord(robot)
            check!(robot,abs(x),abs(y))
        end
    end
end

function check!(robot,x,y) #Проверка координат
    if (x==0 || y==0)
        putmarker!(robot)
    end
end

function numsteps_along!(robot,side)::Int64 #Функция, считающая шаги
num_steps=0
while (!isborder(robot,side))
    move!(robot,side)
    num_steps+=1
end
return num_steps
end


function move_to_angle!(robot, angle=(Sud,West)) #Идём в угол
    back_path = NamedTuple{(:side,:num_steps),Tuple{HorizonSide, Int}}[]
    while !isborder(robot,angle[1]) || !isborder(robot, angle[2])
        push!( back_path, ( side = inverse(angle[1]), num_steps = numsteps_along!(robot, angle[1]) ) )
        push!(back_path, (side = inverse(angle[2]), num_steps = numsteps_along!(robot, angle[2])))  
    end
    return back_path
end

function HorizonSideRobots.move!(robot::CoordRobot, back_path::Vector{NamedTuple{(:side,:num_steps),Tuple{HorizonSide, Int}}}) #Робото возрващается обратно(домой)
    back_path=reverse!(back_path)
    for next in back_path
        along!(robot, next.side, next.num_steps)
    end
end

function along!(robot,side,num_steps)
    for _i in 1:num_steps
        move!(robot,side)
    end
end


function solve_1!(robot)
   back_path=move_to_angle!(robot)
   perimetr_1!(robot)
   HorizonSideRobots.move!(robot,back_path)
end

function solve2_!(robot)
    back_path=move_to_angle!(robot)
    perimetr_2!(robot)
    HorizonSideRobots.move!(robot,back_path)
end


inverse(side::HorizonSide)::HorizonSide = HorizonSide(mod(Int(side)+2, 4))