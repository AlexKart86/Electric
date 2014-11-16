from sympy import *

def load_comments(FileName):
  f=open(FileName, 'r')
  db={}
  for i in f.readlines():
    key, val = i.split('=')
    db[key] = val.strip('\n')
  f.close()
  return db

def prepare_formula(FormulaStr):
  return '{tex}'+FormulaStr+'{\\tex}'

def add_formula(Formula):
  out.write(prepare_formula(str(Formula)))    

def is_digit(str):
  try:
    float(str)
    return True
  except ValueError:
    return False


out=open('out.txt','w')

# Читаем параметры из файла
params=open('params.txt', 'r')
xt = sympify(params.readline())
yt = sympify(params.readline())
t1 = params.readline()
digits=params.readline()
comments_file = params.readline().strip('\n')
comm=load_comments(comments_file)

# v1 - Начальный анализ
out.write('При t=0 ')
t=symbols('t')
x0=xt.evalf(subs={t: 0})
y0=yt.evalf(subs={t: 0})

tmp='x={:.5g}'.format(float(x0))
add_formula(tmp)
out.write(' м ')
tmp='y={:.5g}'.format(float(y0))
add_formula(tmp)
out.write(' м. ')
out.write(comm['v1'])
tmp='M_0({:.5g};{:.5g})'.format(float(x0), float(y0))
add_formula(tmp)
out.write('\n')

# v2 - Определение, уменьшается ли координата точки
x1=xt.evalf(subs={t:0.1})
y1=yt.evalf(subs={t:0.1})
out.write(comm['v2'])
if float(x1)>float(x0):
  out.write(comm['v+'])
else:
  out.write(comm['v-'])

out.write(comm['v21'])
  
if float(y1)>float(y0):
  out.write(comm['v+'])
else:
  out.write(comm['v-'])
out.write(comm['v22']+'\n')
  
#v3 Координаты точки в момент времени t1
x1=xt.evalf(subs={t:t1})
y1=yt.evalf(subs={t:t1})
out.write('При ')
add_formula('t_1={:.5g}'.format(float(t1)))
out.write(' c ')
add_formula('x={:.5g}'.format(float(x1)))
out.write(' м ')
add_formula('y={:.5g}'.format(float(y1)))
out.write(' м ')
out.write('\n'+comm['v33']+' ')
add_formula('M_1=({:.5g};{:.5g})'.format(float(x1), float(y1)))
out.write(' ('+comm['v34']+')\n')

#v4 Проекции вектора скорости
out.write(comm['v41']+'\n')
vx = diff(xt, t)
add_formula('v_x=\\frac{{dx}}{{dt}}=\\frac{{dx}}{{dt}}\\left({!s}\\right)={!s}'.format(latex(xt), latex(vx)))
out.write(' м/с\n')
vy = diff(yt, t)
add_formula('v_y=\\frac{{dy}}{{dt}}=\\frac{{dy}}{{dt}}\\left({!s}\\right)={!s}'.format(latex(yt), latex(vy)))
out.write(' м/с\n')

#v5 В начальный момент времени
out.write(comm['v51']+'\n')
vx0 = vx.subs(t,0)
vy0 = vy.subs(t,0)
if str(vx0).isnumeric():
  add_formula('v_{{0_x}}={!s}'.format(latex(vx0)))
else:
  add_formula('v_{{0_x}}={!s}={:.5g}'.format(latex(vx0), float(vx0.evalf(subs={t, 0}))))
out.write(' м/с\n')

if str(vy0).isnumeric():
  add_formula('v_{{0_y}}={!s}'.format(latex(vy0)))
else:
  add_formula('v_{{0_y}}={!s}={:.5g}'.format(latex(vy0), float(vy0.evalf(subs={t, 0}))))  
out.write(' м/с\n')

out.write(comm['v52'])
x,y=symbols('x y')
expr=sqrt(x**2+y**2)
v0=expr.subs([(x, vx0), (y, vy0)])
tmp_str='v_0=sqrt{{v_{{0_x}}^2+v_{{0_y}}^2}}={!s}'.format(latex(v0))
if not str(v0).isnumeric():
  tmp_str = tmp_str+'={:.5g}'.format(float(v0))  
add_formula(tmp_str)
out.write(' м/с\n')

out.close()
