from sympy import *
import decimal
import numpy as np
import matplotlib.pyplot as plt
import matplotlib as mpl
import matplotlib.patheffects
import datetime

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
	

#Формартирует число в соответствии с требуемой точностью
def format_float(num, is_need_geps=False):
	num=float(num)	
	res='{:.'+str(digits)+'f}'
	res=res.format(decimal.Decimal(num)).rstrip('0').rstrip('.')
	if num<0 and is_need_geps:
	  res='('+res+')'
	if num!='' and res=='':
	  res = '0'	
	return res

class EndArrow(mpl.patheffects._Base):
    """A matplotlib patheffect to add arrows at the end of a path."""
    def __init__(self, headwidth=5, headheight=5, facecolor=(0,0,0), **kwargs):
        super(mpl.patheffects._Base, self).__init__()
        self.width, self.height = headwidth, headheight
        self._gc_args = kwargs
        self.facecolor = facecolor

        self.trans = mpl.transforms.Affine2D()

        self.arrowpath = mpl.path.Path(
                np.array([[-0.5, -0.2], [0.0, 0.0], [0.5, -0.2], 
                          [0.0, 1.0], [-0.5, -0.2]]),
                np.array([1, 2, 2, 2, 79]))

    def draw_path(self, renderer, gc, tpath, affine, rgbFace):
        scalex = renderer.points_to_pixels(self.width)
        scaley = renderer.points_to_pixels(self.height)

        x0, y0 = tpath.vertices[-1]
        dx, dy = tpath.vertices[-1] - tpath.vertices[-2]
        azi =  np.arctan2(dy, dx) - np.pi / 2.0 
        trans = affine + self.trans.clear(
                ).scale(scalex, scaley
                ).rotate(azi
                ).translate(x0, y0)

        gc0 = renderer.new_gc()
        gc0.copy_properties(gc)
        self._update_gc(gc0, self._gc_args)

        if self.facecolor is None:
            color = rgbFace
        else:
            color = self.facecolor

        renderer.draw_path(gc0, self.arrowpath, trans, color)
        renderer.draw_path(gc, tpath, affine, rgbFace)
        gc0.restore()

class CenteredFormatter(mpl.ticker.ScalarFormatter):
    """Acts exactly like the default Scalar Formatter, but yields an empty
    label for ticks at "center"."""
    center = 0
    def __call__(self, value, pos=None):
        if value == self.center:
            return ''
        else:
            return mpl.ticker.ScalarFormatter.__call__(self, value, pos)        

def center_spines(ax=None):
    """Centers the axis spines at <centerx, centery> on the axis "ax", and
    places arrows at the end of the axis spines."""
    if ax is None:
        ax = plt.gca()

    # Set the axis's spines to be centered at the given point
    # (Setting all 4 spines so that the tick marks go in both directions)
    ax.spines['left'].set_position(('data', 0))
    ax.spines['bottom'].set_position(('data',0))    
    ax.spines['top'].set_position(('data', 0))
    ax.spines['right'].set_position(('data', 0))
    ax.spines['top'].set_color('none')
    ax.spines['right'].set_color('none')      
    # Draw an arrow at the end of the spines	
    for axis, center in zip([ax.xaxis, ax.yaxis], [0, 0]):
        # Turn on minor and major gridlines and ticks        
        formatter = CenteredFormatter()
        formatter.center = center
        axis.set_major_formatter(formatter)
    ax.annotate('0', xy=(0, 0), xytext=(-4, -4), textcoords='offset points', ha='right', va='top')
    ax.spines['left'].set_path_effects([EndArrow()])
    ax.spines['bottom'].set_path_effects([EndArrow()])	
	
def print_graph():
  def add_point(px, py, txt, clr='green'):
    plt.plot([px, px], [0, py], linestyle='--', color=clr)
    plt.plot([px, 0], [py, py], linestyle='--', color=clr)
    plt.scatter([px,], [py,], 30, color=clr)
    plt.annotate(r'$'+txt+'$',
         xy=(px, py), xycoords='data',
         xytext=(+5, +5), textcoords='offset points')
    if px!=0:
      plt.annotate(r'$'+format_float(px)+'$',
           xy=(px, 0), xycoords='data',
           xytext=(-8, +5), textcoords='offset points', fontsize=8)
    if py!=0:  
      plt.annotate(r'$'+format_float(py)+'$',
          xy=(0, py), xycoords='data',
          xytext=(-20, 0), textcoords='offset points', fontsize=8)
  tx = []
  ty = []
  q = float(tmin)
  while q<=float(tmax):
    tx.append(xt.evalf(subs={t: q}))
    ty.append(yt.evalf(subs={t: q}))
    q = q+ 0.05

  #Границы построения графика
    plt.xlim(xmin, xmax+0.2)
    plt.ylim(ymin, ymax+0.2)
  #Центрируем оси координат, если 0 прлбегается по х и по у
  if xmin <0 and xmax>0 and ymin<0 and ymax >0:
    center_spines()	
##  plt.axis('equal')
  #Строим основной график
  plt.plot(tx, ty)
  #Отмечаем точку M_0
  add_point(x0, y0, 'M_0')
  add_point(x1, y1, 'M_1')

  ax = plt.gca()
  if float(vx0) != 0:
    ax.quiver(float(x0), float(y0), float(vx0), 0, angles='xy', scale_units='xy',scale=1, width=0.003, linewidth=0.01, color='red') 
    plt.annotate(r'$\overrightarrow{v_{0x}}$',
         xy=(float(vx0+x0), float(y0)), xycoords='data',
         xytext=(-5, -10), textcoords='offset points')  
  if float(vy0) != 0:
    ax.quiver(float(x0), float(y0), 0, float(vy0), angles='xy', scale_units='xy',scale=1, width=0.003, linewidth=0.01, color='red') 
    plt.annotate(r'$\overrightarrow{v_{0y}}$',
         xy=(float(x0), float(y0+vy0)), xycoords='data',
         xytext=(5, 0), textcoords='offset points')  
  ax.quiver(float(x1), float(y1), float(vx1), float(vy1), angles='xy', scale_units='xy',scale=1, width=0.003, linewidth=0.01, color='red') 
  plt.annotate(r'$\overrightarrow{v_1}$',
         xy=(float(vx1+x1), float(y1+vy1)), xycoords='data',
         xytext=(-10, -10), textcoords='offset points')
  #ax.quiver(float(x1), float(y1), float(wx1), float(wy1), angles='xy', scale_units='xy',scale=1, width=0.005, linewidth=0.01) 
  #Проекция
  #mod=w1t/sqrt(x1*x1+y1*y1)
  #print(float(vx1*mod), float(vy1*mod))

  if w1t<0:
    wTx = -float(vx1)/2
    wTy = -float(vy1)/2
    wNx = wTy
    wNy = -wTx    
  else:
    wTx = float(vx1*0.5)
    wTy = float(vy1*0.5)
    wNx = -wTy
    wNy = wTx

  wRx = 1.5*wNx
  wRy = 1.5*wNy

  #Рисуем векторы ускорения
  ax.quiver(float(x1), float(y1), wTx, wTy, angles='xy', scale_units='xy',scale=1, width=0.003, linewidth=0.01, color='red')
  ax.quiver(float(x1), float(y1), wNx, wNy, angles='xy', scale_units='xy',scale=1, width=0.003, linewidth=0.01, color='red')
  ax.quiver(float(x1), float(y1), wTx+wNx, wTy+wNy, angles='xy', scale_units='xy',scale=1, width=0.003, linewidth=0.01, color='red')
  
  #Рисуем пунктирніе линии для векторов ускорения
  plt.plot([wTx+x1,wTx+wNx+x1], [wTy+y1,wTy+wNy+y1], linestyle='--', color='red')
  plt.plot([wNx+x1,wTx+wNx+x1], [wNy+y1,wTy+wNy+y1], linestyle='--', color='red')

  #Подписи
  plt.annotate(r'$\overrightarrow{W_1^{\tau}}$',
         xy=(wTx+x1, wTy+y1), xycoords='data',
         xytext=(-10, -10), textcoords='offset points')
  plt.annotate(r'$\overrightarrow{W_1}$',
         xy=(wTx+wNx+x1,wTy+wNy+y1), xycoords='data',
         xytext=(+5, +5), textcoords='offset points')   
  plt.annotate(r'$\overrightarrow{W_1^n}$',
         xy=(wNx+x1, wNy+y1), xycoords='data',
         xytext=(+5, +5), textcoords='offset points')

  #Рисуем вектор r1
  plt.plot([float(x1), float(x1)+wRx], [float(y1), float(y1)+wRy], color='red');
  plt.scatter([float(x1)+wRx,], [float(y1)+wRy,], 20, color='red')
  plt.annotate(r'$O$',
         xy=(float(x1)+wRx, float(y1)+wRy), xycoords='data',
         xytext=(+5, +5), textcoords='offset points')
  plt.annotate(r'$\rho_1$',
         xy=(wRx/2+x1, wRy/2+y1), xycoords='data',
         xytext=(+5, +5), textcoords='offset points')

  #Подписываем оси координат
  ax.quiver(xmax, 0, 0.2, 0, angles='xy', scale_units='xy',scale=1, width=0.004, linewidth=0.0001, color='black')
  ax.quiver(0, ymax, 0, 0.2, angles='xy', scale_units='xy',scale=1, width=0.004, linewidth=0.0001, color='black')
  ax.annotate('X', xy=(xmax+0.2, 0), xytext=(-4, 14), textcoords='offset points', ha='right', va='top')
  ax.annotate('Y', xy=(0, ymax+0.2), xytext=(-8, -1), textcoords='offset points', ha='right', va='top')
  
  #Делаем меньше отступы
  plt.subplots_adjust(left=0.02, right=0.98, top=0.98, bottom=0.02)
  plt.savefig('img.png', papertype='a4')	
  	


out=open('out.txt','w')

# Читаем параметры из файла
params=open('params.txt', 'r')
xt = sympify(params.readline())
yt = sympify(params.readline())
t1 = params.readline().strip('\n')
tmin = params.readline().strip('\n')
tmax = params.readline().strip('\n')
xmin = float(params.readline().strip('\n'))
xmax = float(params.readline().strip('\n'))
ymin = float(params.readline().strip('\n'))
ymax = float(params.readline().strip('\n'))
digits=params.readline().strip('\n')
comments_file = params.readline().strip('\n')
params.close()

comm=load_comments(comments_file)

t=symbols('t')

# v1 - Начальный анализ
out.write('При t=0 ')

x0=xt.evalf(subs={t: 0})
y0=yt.evalf(subs={t: 0})

tmp='x='+format_float(float(x0))
add_formula(tmp)
out.write(' м ')
tmp='y='+format_float(float(y0))
add_formula(tmp)
out.write(' м. ')
out.write(comm['v1'])
tmp='M_0({!s};{!s})'.format(format_float(float(x0)), format_float(float(y0)))
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
add_formula('t_1={!s}'.format(format_float(t1)))
out.write(' c ')
add_formula('x={!s}'.format(format_float(x1)))
out.write(' м ')
add_formula('y={!s}'.format(format_float(y1)))
out.write(' м ')
out.write('\n'+comm['v33']+' ')
add_formula('M_1=({!s};{!s})'.format(format_float(x1), format_float(y1)))
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
  add_formula('v_{{0_x}}={!s}={!s}'.format(latex(vx0), format_float(vx0.evalf(subs={t, 0}))))
out.write(' м/с\n')

if str(vy0).isnumeric():
  add_formula('v_{{0_y}}={!s}'.format(latex(vy0)))
else:
  add_formula('v_{{0_y}}={!s}={!s}'.format(latex(vy0), format_float(vy0.evalf(subs={t, 0}))))  
out.write(' м/с\n')

out.write(comm['v52'])
x,y=symbols('x y')
expr=sqrt(x**2+y**2)
v0=expr.subs([(x, vx0), (y, vy0)])
tmp_str='v_0=sqrt{{v_{{0_x}}^2+v_{{0_y}}^2}}=sqrt{{{!s}^2+{!s}^2}}={!s}'.format(format_float(vx0, True), format_float(vy0, True), format_float(v0))
add_formula(tmp_str)
out.write(' м/с\n')

if format_float(float(v0))=='0':
  out.write(comm['v53'])
  add_formula('v0=0')
  out.write(comm['v54'])
else:  
  #v6 Направляющие косинусы   
  out.write(comm['v60']+'\n')
  add_formula('\\cos(ox,\overrightarrow{{v_0}})=\\frac{{v_{{0_x}}}}{{v_0}}=\\frac{{{!s}}}{{{!s}}}={!s}'.format(format_float(vx0), format_float(v0), format_float(vx0/v0)))
  out.write('\n')
  add_formula('\\cos(oy,\overrightarrow{{v_0}})=\\frac{{v_{{0_y}}}}{{v_0}}=\\frac{{{!s}}}{{{!s}}}={!s}'.format(format_float(vy0), format_float(v0), format_float(vy0/v0)))
  out.write('\n')

#v7 В момент времени t1
out.write(comm['v70']+' ')
add_formula('t_1={!s}'.format(format_float(t1)))
out.write('\n')
vx1 = vx.subs(t,t1)
vy1 = vy.subs(t,t1)
if str(vx1).isnumeric():
  add_formula('v_{{1_x}}={!s}'.format(latex(vx1)))
else:
  add_formula('v_{{1_x}}={!s}={!s}'.format(latex(vx1), format_float(vx1)))
out.write(' м/с\n')
if str(vy1).isnumeric():
  add_formula('v_{{1_y}}={!s}'.format(latex(vy1)))
else:
  add_formula('v_{{1_y}}={!s}={!s}'.format(latex(vy1), format_float(vy1)))  
out.write(' м/с\n')

expr=sqrt(x**2+y**2)
v1=expr.subs([(x, vx1), (y, vy1)])
tmp_str='v_1=sqrt{{v_{{1_x}}^2+v_{{1_y}}^2}}=sqrt{{{!s}^2+{!s}^2}}={!s}'.format(format_float(vx1, True), format_float(vy1, True), format_float(v1))
add_formula(tmp_str)
out.write(' м/с\n')
out.write(comm['v71']+'\n')
add_formula('\\cos(ox,\overrightarrow{{v_1}})=\\frac{{v_{{1_x}}}}{{v_1}}=\\frac{{{!s}}}{{{!s}}}={!s}'.format(format_float(vx1), format_float(v1), format_float(vx1/v1)))
out.write('\n')
add_formula('\\cos(oy,\overrightarrow{{v_1}})=\\frac{{v_{{1_y}}}}{{v_1}}=\\frac{{{!s}}}{{{!s}}}={!s}'.format(format_float(vy1), format_float(v1), format_float(vy1/v1)))
out.write('\n')


#8
out.write(comm['v80']+'\n')
Wx=diff(vx,t)
Wy=diff(vy,t)
add_formula('W_x=\\frac{{dv_x}}{{dt}}=\\frac{{dx}}{{dt}}\\left({!s}\\right)={!s}, \\; \\frac{{\\cyr{{m}}}}{{c^2}}'.format(latex(vx), latex(Wx)))
out.write('\n')
add_formula('W_y=\\frac{{dv_y}}{{dt}}=\\frac{{dy}}{{dt}}\\left({!s}\\right)={!s}, \\; \\frac{{\\cyr{{m}}}}{{c^2}}'.format(latex(vy), latex(Wy)))
out.write('\n')
out.write(comm['v81']+' ')
add_formula('t=0')
wx0=Wx.subs(t,0)
wy0=Wy.subs(t,0)
out.write('\n')
add_formula('W_{{0_x}}={!s}, \\;  \\frac{{\\cyr{{m}}}}{{c^2}}'.format(format_float(wx0)))
out.write('\n')
add_formula('W_{{0_y}}={!s}, \\;  \\frac{{\\cyr{{m}}}}{{c^2}}'.format(format_float(wy0)))
out.write('\n')
out.write(comm['v82']+' ');
expr=sqrt(x**2+y**2)
w0=expr.subs([(x, wx0), (y, wy0)])
tmp_str='W_0=sqrt{{W_{{0_x}}^2+W_{{0_y}}^2}}=sqrt{{{!s}^2+{!s}^2}}={!s},\\; \\frac{{\\cyr{{m}}}}{{c^2}}'.format(format_float(wx0, True), format_float(wy0, True), format_float(w0))
add_formula(tmp_str)
out.write('\n');
out.write(comm['v84']+'\n')
add_formula('\\cos(ox,\overrightarrow{{W_0}})=\\frac{{W_{{0_x}}}}{{W_0}}=\\frac{{{!s}}}{{{!s}}}={!s}'.format(format_float(wx0), format_float(w0), format_float(wx0/w0)))
out.write('\n')
add_formula('\\cos(oy,\overrightarrow{{W_0}})=\\frac{{W_{{0_y}}}}{{W_0}}=\\frac{{{!s}}}{{{!s}}}={!s}'.format(format_float(wx0), format_float(w0), format_float(wy0/w0)))
out.write('\n')
out.write(comm['v83']+' ')
add_formula('t_1={!s}'.format(format_float(t1)))
out.write('\n')
wx1 = Wx.subs(t,t1)
wy1 = Wy.subs(t,t1)

if str(wx1).isnumeric():
  add_formula('W_{{1_x}}={!s},\\; \\frac{{\\cyr{{m}}}}{{c^2}}'.format(latex(wx1)))
else:
  add_formula('W_{{1_x}}={!s}={!s},\\; \\frac{{\\cyr{{m}}}}{{c^2}}'.format(latex(wx1), format_float(wx1)))

out.write('\n')
  
if str(wy1).isnumeric():
  add_formula('W_{{1_y}}={!s},\\; \\frac{{\\cyr{{m}}}}{{c^2}}'.format(latex(wy1)))
else:
  add_formula('W_{{1_y}}={!s}={!s},\\; \\frac{{\\cyr{{m}}}}{{c^2}}'.format(latex(wy1), format_float(wy1)))  
out.write('\n')

out.write(comm['v82']+' ');
expr=sqrt(x**2+y**2)
w1=expr.subs([(x, wx1), (y, wy1)])
tmp_str='W_1=sqrt{{W_{{1_x}}^2+W_{{1_y}}^2}}=sqrt{{{!s}^2+{!s}^2}}={!s},\\; \\frac{{\\cyr{{m}}}}{{c^2}}'.format(format_float(wx1, True), format_float(wy1, True), format_float(w1))
add_formula(tmp_str)
out.write('\n')

out.write(comm['v85']+' ')
add_formula('t_1')
out.write('\n')
add_formula('\\cos(ox,\overrightarrow{{W_1}})=\\frac{{W_{{1_x}}}}{{W_1}}=\\frac{{{!s}}}{{{!s}}}={!s}'.format(format_float(wx1), format_float(w1), format_float(wx1/w1)))
out.write('\n')
add_formula('\\cos(oy,\overrightarrow{{W_1}})=\\frac{{W_{{1_y}}}}{{W_1}}=\\frac{{{!s}}}{{{!s}}}={!s}'.format(format_float(wx1), format_float(w1), format_float(wy1/w1)))
out.write('\n')


#9
out.write(comm['v90']+' ')
add_formula('\overrightarrow{{W_1}}')
out.write(comm['v91'])
out.write('\n')
add_formula('W_1^{{\\tau}}=\\frac{{v_{{1_x}} \\cdot W_{{1_x}}+v_{{1_y}} \\cdot W_{{1_y}}}}{{v_1}}')
out.write('\n'+comm['v92']+'\n')
w1t=(vx1*wx1+vy1*wy1)/v1
add_formula('W_1^{{\\tau}}=\\frac{{{!s}\\cdot {!s}+ {!s} \\cdot {!s} }}{{ {!s} }}={!s},\\; \\frac{{\\cyr{{m}}}}{{c^2}}'.format(
    format_float(vx1, True), 
	format_float(wx1, True),
	format_float(vy1, True),
	format_float(wy1, True),
	format_float(v1, True),
	format_float(w1t, True)))
out.write('\n')	
if w1t>0:
  out.write(comm['v93+'])
else:
  out.write(comm['v93-'])

out.write('\n')
out.write(comm['v94']+'\n')
w1n=sqrt(w1*w1-w1t*w1t)
add_formula('W_1^n=\\sqrt{{W_1^2-(W_1^{{\\tau}})^2}}=\\sqrt{{ ({!s})^2-({!s})^2}}={!s},\\; \\frac{{\\cyr{{m}}}}{{c^2}}'.format(
       format_float(w1),
	   format_float(w1t),
	   format_float(w1n)))
out.write('\n')	   
out.write(comm['v95']+'\n')
add_formula('W^n=\\|\\frac{{v_xW_y-v_yW_x}}{{v}}\\|')
out.write('\n')	   
out.write(comm['v96']+'\n')
w1n1=abs((vx1*wy1-vy1*wx1)/v1)	
add_formula('W_1^n=\\|\\frac{{v_{{1_x}}W_{{1_y}}-v_{{1_y}}W_{{1_x}}}}{{v_1}}\\|=\\|\\frac{{{!s}\\cdot{!s}-{!s}\\cdot{!s}}}{{{!s}}}\\|={!s},\\; \\frac{{\\cyr{{m}}}}{{c^2}}'.format(	  
	   format_float(vx1, True),
	   format_float(wy1, True),
	   format_float(vy1, True),
	   format_float(wx1, True),   
	   format_float(v1, True),
	   format_float(w1n1, True)))
out.write('\n'+comm['v97']+'\n')
r1=v1*v1/w1n1
add_formula('\\rho_1=\\frac{{v_1^2}}{{W_1^n}}=\\frac{{{!s}^2}}{{{!s}}}={!s}'.format(
	   format_float(v1, True),
	   format_float(w1n1),
	   format_float(r1)))
out.write('  м')
out.write('\n'+comm['v100']+'\n')
out.close()

#10 Написание ответа
#Пишем в два файла 

#Первый столбик
out = open('res_1.txt', 'w')
add_formula('t_0=0\\;c')
out.write('\n')
add_formula('M_0({!s};{!s})'.format(format_float(float(x0)), format_float(float(y0))))
out.write('\n')
add_formula('v_0_x={!s}'.format(format_float(vx0)))
out.write('\n')
add_formula('v_0_y={!s}'.format(format_float(vy0)))
out.write('\n')
add_formula('v_0={!s}'.format(format_float(v0)))
out.write('\n')
add_formula('W_{{0_x}}={!s}'.format(format_float(wx0)))
out.write('\n')
add_formula('W_{{0_y}}={!s}'.format(format_float(wy0)))
out.write('\n')
add_formula('W_0={!s}'.format(format_float(w0)))
out.close()

#Второй столбик
out = open('res_2.txt', 'w')
add_formula('t_1='+latex(t1)+'\\;c')
out.write('\n')
add_formula('M_1({!s};{!s})'.format(format_float(x1), format_float(y1)))
out.write('\n')
add_formula('v_1_x={!s}'.format(format_float(vx1)))
out.write('\n')
add_formula('v_1_y={!s}'.format(format_float(vy1)))
out.write('\n')
add_formula('v_1={!s}'.format(format_float(v1)))
out.write('\n')
add_formula('W_{{1_x}}={!s}'.format(format_float(wx1)))
out.write('\n')
add_formula('W_{{1_y}}={!s}'.format(format_float(wy1)))
out.write('\n')
add_formula('W_1={!s}\\; \\frac{{\\cyr{{m}}}}{{c^2}}'.format(format_float(w1)))
out.write('\n')
add_formula('W_1^{{\\tau}}={!s}'.format(format_float(w1t)))
out.write('\n')
add_formula('W_1^n={!s}'.format(format_float(w1n)))
out.write('\n')
add_formula('\\rho_1=OM_1={!s}'.format(format_float(r1)))
out.close()

#Пишем в файл результаты
out = open('graph_params.txt', 'w')
out.write('x0={!s}\n'.format(format_float(float(x0))))
out.write('y0={!s}\n'.format(format_float(float(y0))))
out.write('vx0={!s}\n'.format(format_float(vx0)))
out.write('vy0={!s}\n'.format(format_float(vy0)))
out.write('x1={!s}\n'.format(format_float(float(x1))))
out.write('y1={!s}\n'.format(format_float(float(y1))))
out.write('vx1={!s}\n'.format(format_float(float(vx1))))
out.write('vy1={!s}\n'.format(format_float(float(vy1))))
out.write('wx1={!s}\n'.format(format_float(float(wx1))))
out.write('wy1={!s}\n'.format(format_float(float(wy1))))
out.write('w1t={!s}\n'.format(format_float(float(w1t))))
out.close()
