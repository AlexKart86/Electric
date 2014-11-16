from sympy import *
def prepare_formula(FormulaStr):
  return '{tex}'+FormulaStr+'{\\tex}'
def add_formula(Formula):
  out.write(prepare_formula(str(Formula)))
out=open('out_task.txt','w')
params=open('params.txt', 'r')
xt = sympify(params.readline())
yt = sympify(params.readline())
t1 = params.readline().strip('\n')
params.close()
t=symbols('t')
add_formula('x(t)='+latex(xt))
out.write(', м')
add_formula('y(t)='+latex(yt))
out.write(', м')
add_formula('t_1='+latex(t1))
out.write(', с')
out.close()
