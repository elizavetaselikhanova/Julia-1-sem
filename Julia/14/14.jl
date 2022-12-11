#Решить предыдущую задачу, но при условии наличия на поле 'простых' внутренних перегородок

#Ввести в терминал:
#>julia
#using HorizonSideRobots
#include("14.jl")
#mutable struct Coordinates
#    x::Int
#    y::Int
#end
#Coordinates() = Coordinates(0,0)

#function HorizonSideRobots.move!(coord::Coordinates, side::HorizonSide)
#   if side==Nord
#        coord.y += 1
#    elseif side==Sud
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
#    move!(robot.robot, side)
#    move!(robot.coord, side)
#end
#HorizonSideRobots.isborder(robot::CoordRobot, side) = isborder(robot.robot, side)
#HorizonSideRobots.putmarker!(robot::CoordRobot) = putmarker!(robot.robot)
#HorizonSideRobots.ismarker(robot::CoordRobot) = ismarker(robot.robot)
#HorizonSideRobots.temperature(robot::CoordRobot) = temperature(robot.robot)

#get_coord(robot::CoordRobot) = get_coord(robot.coord)

#r=CoordRobot(Robot("14.sit",animate=true), Coordinates(0,0))
#solve!(r)

function try_move!(robot, side)
    check!(robot)
    if isborder(robot, side)
        return false
    else       
        move!(robot, side)
        check!(robot)
        return true
    end
end

function wall_recursion!(robot,side) #Рекурсивный способ обхода стены
    if (isborder(robot,side))
        if (try_move!(robot,right(side)) )
                wall_recursion!(robot,side)
                move!(robot,inverse(right(side)))
        else
            return false
        end
    else
        move!(robot,side)
    end
end



function  go_to_corner!(robot,num_steps_Sud,num_steps_West)
    while (!isborder(robot,Sud))
        move!(robot,Sud)
        num_steps_Sud+=1
     end
     while (!isborder(robot,West))
        move!(robot,West)
        num_steps_West+=1
     end
end


function along_try!(robot, side)
    for _i in 1:11
        check!(robot)
        wall_recursion!(robot,side)            
        check!(robot)
    end
end

function snake!( robot, (move_side, next_row_side)::NTuple{2,HorizonSide} = (Nord, Ost)) 
    along_try!(robot, move_side)
    while try_move!(robot, next_row_side)
        move_side = inverse(move_side)
        along_try!(robot, move_side)
    end
end

function find_corner!(robot) #Поиск угла
    num_steps_West=0
    num_steps_Sud=0
 while (!isborder(robot,Sud))
    move!(robot,Sud)
    num_steps_Sud+=1
 end
 while (!isborder(robot,West))
    move!(robot,West)
    num_steps_West+=1
 end
    return num_steps_Sud,num_steps_West
end

function go_to_home!(robot,num_steps_Sud,num_steps_West) #Возвращается обратно(домой)
    for _i in 1:num_steps_Sud
        move!(robot,Nord)
    end
    for _i in 1:num_steps_West
        move!(robot,Ost)
    end
end

function check!(robot) #Проверка координат
    x,y=get_coord(robot)
    if ( ( ( abs(x+y) )%2 )==0 )
        putmarker!(robot)
    end
end


function solve!(robot,(side1, side2)::NTuple{2,HorizonSide} = (Ost, Nord))
   num_steps_Sud,num_steps_West=find_corner!(robot)
   snake!(robot,(side1,side2))
   go_to_corner!(robot,num_steps_Sud,num_steps_West)
   go_to_home!(robot,num_steps_Sud,num_steps_West)
end

inverse(side::HorizonSide) = HorizonSide((Int(side) +2)% 4)
right(side::HorizonSide) = HorizonSide((Int(side) +3)% 4)