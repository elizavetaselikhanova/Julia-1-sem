#Задача 8.Где-то на неогранниченном со всех сторон поле без внутренних перегородок имеется единственный маркер. Робот в произвольной клетке этого поля.
#Итог: Робот в клетке с маркером.

#Ввести в терминал:
#>julia
#using HorizonSideRobots
#include("8.jl")
#r=Robot("8.sit",animate=true)
#solve!(r)

function find_marker!(robot) #Функция, ищущая маркер
    k=0
    side=Nord
    while (!ismarker(robot))
      for _i in 1:2
        along!(side,k,robot)
        side=right(side)
      end
      k+=1
    end
  end
  
  function along!(side,num_steps,robot)
    for _i in 1:num_steps
      if (!ismarker(robot))
        move!(robot,side)
      end
    end
  end
  
  
  function solve!(robot)
  find_marker!(robot)
  end
  
  right(side::HorizonSide)::HorizonSide = HorizonSide(mod(Int(side)+1, 4))