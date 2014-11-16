from sympy import *
import decimal
import math
import numpy as np
import matplotlib.pyplot as plt
import matplotlib as mpl
import matplotlib.patheffects

class CenteredFormatter(mpl.ticker.ScalarFormatter):
    """Acts exactly like the default Scalar Formatter, but yields an empty
    label for ticks at "center"."""
    center = 0
    def __call__(self, value, pos=None):
        if value == self.center:
            return ''
        else:
            return mpl.ticker.ScalarFormatter.__call__(self, value, pos)        

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
	
def print_graph():
  def add_point(px, py, txt, clr='green', x=-20, y=0):
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
          xytext=(x, y), textcoords='offset points', fontsize=8)
  x1 = vars['x1']
  y1 = vars['y1']
  tx = []
  ty = []
  q = float(tmin)
  h= (tmax-tmin)/200
  while q<=float(tmax):
    tx.append(xt.evalf(subs={t: q}))
    ty.append(yt.evalf(subs={t: q}))
    q = q+h
  plt.xlim(xmin, xmax+0.2)
  plt.ylim(ymin, ymax+0.2)
  #Центрируем оси координат, если 0 прлбегается по х и по у
  if xmin <0 and xmax>0 and ymin<0 and ymax >0:
    center_spines()	
  #Строим основной график
  plt.plot(tx, ty)
  #Отмечаем точку M_0
  add_point(vars['x0'], vars['y0'], 'M_0', x=marks['x'], y=marks['y'])
  add_point(x1, y1, 'M_1', x=marks['x1'], y=marks['y1'])

  ax = plt.gca()  
  if vars['w1t']<0:
    wTx = -vars['vx1']*abs(marks['Wnkoeff'])
    wTy = -vars['vy1']*abs(marks['Wnkoeff'])
  else:
    wTx = vars['vx1']*abs(marks['Wnkoeff'])
    wTy = vars['vy1']*abs(marks['Wnkoeff'])

  wNx = vars['vy1']*marks['Wnkoeff']
  wNy = -vars['vx1']*marks['Wnkoeff']
  wRx = wNx*marks['Rkoeff']/abs(marks['Wnkoeff'])
  wRy = wNy*marks['Rkoeff']/abs(marks['Wnkoeff'])
  

  #Рисуем векторы ускорения
  ax.quiver(x1, y1, wTx, wTy, angles='xy', scale_units='xy',scale=1, width=0.003, linewidth=0.01, color='red')
  ax.quiver(x1, y1, wNx, wNy, angles='xy', scale_units='xy',scale=1, width=0.003, linewidth=0.01, color='red')
  ax.quiver(x1, y1, wTx+wNx, wTy+wNy, angles='xy', scale_units='xy',scale=1, width=0.003, linewidth=0.01, color='red')
  
  #Рисуем пунктирніе линии для векторов ускорения
  plt.plot([wTx+x1,wTx+wNx+x1], [wTy+y1,wTy+wNy+y1], linestyle='--', color='red')
  plt.plot([wNx+x1,wTx+wNx+x1], [wNy+y1,wTy+wNy+y1], linestyle='--', color='red')

  #Подписи
  plt.annotate(r'$\overrightarrow{W_1^{\tau}}$',
         xy=(wTx+x1, wTy+y1), xycoords='data',
         xytext=(marks['wtx1'], marks['wty1']), textcoords='offset points')
  plt.annotate(r'$\overrightarrow{W_1}$',
         xy=(wTx+wNx+x1,wTy+wNy+y1), xycoords='data',
         xytext=(marks['wx1'], marks['wy1']), textcoords='offset points')   
  plt.annotate(r'$\overrightarrow{W_1^n}$',
         xy=(wNx+x1, wNy+y1), xycoords='data',
         xytext=(marks['wnx1'], marks['wny1']), textcoords='offset points')

  #Рисуем вектор r1
  plt.plot([x1, x1+wRx], [y1, y1+wRy], color='red');
  plt.scatter([x1+wRx,], [y1+wRy,], 20, color='red')
  plt.annotate(r'$O$',
         xy=(x1+wRx, y1+wRy), xycoords='data',
         xytext=(marks['ox'], marks['oy']), textcoords='offset points')
  plt.annotate(r'$\rho_1$',
         xy=(wRx/2+x1, wRy/2+y1), xycoords='data',
         xytext=(marks['rx0'], marks['ry0']), textcoords='offset points')

  #Подписываем оси координат
  #plt.arrow(0, ymax-2, 0, ymax+1, arrowstyle='->')
  #ax.quiver(xmax-0.5, 0, 1, 0, units='dots', angles='xy', scale_units='xy',scale=1, width=0.004, linewidth=0.0001, color='black')
  #ax.quiver(0, ymax, 0, 400, angles='xy', scale_units='dots',scale=1, width=0.004, linewidth=0.0001, color='black')
  ax.annotate('X', xy=(xmax+0.2, 0), xytext=(-4, 14), textcoords='offset points', ha='right', va='top')
  ax.annotate('Y', xy=(0, ymax+0.2), xytext=(10, -1), textcoords='offset points', ha='right', va='top')

  #Рисуем векторы скорости, предварительно уменьшив координаты их концов на коэффициент сжатия
  vars['vx0'] = vars['vx0']*marks['Vkoeff']
  vars['vy0'] = vars['vy0']*marks['Vkoeff']
  vars['vx1'] = vars['vx1']*marks['Vkoeff']
  vars['vy1'] = vars['vy1']*marks['Vkoeff']
  if vars['vx0'] != 0:
    ax.quiver(vars['x0'], vars['y0'], vars['vx0'], 0, angles='xy', scale_units='xy',scale=1, width=0.003, linewidth=0.01, color='red') 
    plt.annotate(r'$\overrightarrow{v_{0x}}$',
         xy=(vars['vx0']+vars['x0'], vars['y0']), xycoords='data',
         xytext=(marks['vx0'], marks['vy0']), textcoords='offset points')  
  if float(vars['vy0']) != 0:
    ax.quiver(vars['x0'], vars['y0'], 0, vars['vy0'], angles='xy', scale_units='xy',scale=1, width=0.003, linewidth=0.01, color='red') 
    plt.annotate(r'$\overrightarrow{v_{0y}}$',
         xy=(vars['x0'], vars['y0']+vars['vy0']), xycoords='data',
         xytext=(marks['x0'], marks['y0']), textcoords='offset points')  
  ax.quiver(x1, y1, vars['vx1'], vars['vy1'], angles='xy', scale_units='xy',scale=1, width=0.003, linewidth=0.01, color='red') 
  plt.annotate(r'$\overrightarrow{v_1}$',
         xy=(vars['vx1']+x1, y1+vars['vy1']), xycoords='data',
         xytext=(marks['vx1'], marks['vy1']), textcoords='offset points')
  
  #Делаем меньше отступы
  plt.subplots_adjust(left=0.02, right=0.98, top=0.98, bottom=0.02)
  plt.savefig('img.png', papertype='a4')	

def load_info(FileName):
  f=open(FileName, 'r')
  db={}
  for i in f.readlines():
    key, val = i.split('=')
    db[key] = float(val.strip('\n'))
  f.close()
  return db
  

# Читаем параметры из файла
params=open('params.txt', 'r')
xt = sympify(params.readline())
yt = sympify(params.readline())
t1 = params.readline().strip('\n')
tmin = float(params.readline().strip('\n'))
tmax = float(params.readline().strip('\n'))
xmin = float(params.readline().strip('\n'))
xmax = float(params.readline().strip('\n'))
ymin = float(params.readline().strip('\n'))
ymax = float(params.readline().strip('\n'))
digits=params.readline().strip('\n')
t=symbols('t')
vars=load_info('graph_params.txt')
marks=load_info('mark_coords.txt')
print_graph()


