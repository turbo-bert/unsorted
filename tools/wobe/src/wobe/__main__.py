import tkinter as tk
import tkinter.simpledialog
import sys
import os
import subprocess


source_dir = os.path.abspath(sys.argv[1])
if len(sys.argv) > 2:
    f_i_max = int(sys.argv[2])
else:
    f_i_max = 5

def starter(filename, directory):
    if filename.endswith('.i.term.sh'):
        i = tkinter.simpledialog.askinteger(title="Run with Parameter", prompt="Integer")
        if i is not None:
            term_run_macos("cd '%s' && bash '%s' %d" % (directory, filename, int(i)))
    elif filename.endswith('.term.sh'):
        term_run_macos("cd '%s' && bash '%s'" % (directory, filename))
    elif filename.endswith('.mterm.sh'):
        term_run_macos_mini("cd '%s' && bash '%s'" % (directory, filename))
    else:
        subprocess.Popen("cd '%s' && bash '%s'" % (directory, filename), shell=True)

def term_run_macos(cmd):
    p = subprocess.Popen("""osascript""", shell=True, universal_newlines=True, stdin=subprocess.PIPE)
    p.communicate(input='tell app "Terminal" to do script "%s"' % cmd, timeout=10)
    #p.wait()

def term_run_macos_mini(cmd):
    cmd = "resize -s 8 50; %s" % cmd
    p = subprocess.Popen("""osascript""", shell=True, universal_newlines=True, stdin=subprocess.PIPE)
    p.communicate(input='tell app "Terminal" to do script "%s"' % cmd, timeout=10)
    #p.wait()


files = []
for f in os.listdir(source_dir):
    full = os.path.join(source_dir, f)
    #print(full)
    if os.path.isfile(full) and f.endswith('.sh'):
        files.append(f)

files = list(sorted(files))

workbench_title = source_dir.split('/')[-1]

root = tk.Tk()
root.title('%s' % workbench_title)
#root.attributes("-topmost", True)

#root.geometry('180x%d' % int(5+len(files)*44))

##from sys import platform
##
##if platform == 'darwin':
##    from Foundation import NSBundle
##    bundle = NSBundle.mainBundle()
##    if bundle:
##        info = bundle.localizedInfoDictionary() or bundle.infoDictionary
##        if info and info['CFBundleName'] == 'Python':
##            info['CFBundleName'] == 'Workbench %s' % workbench_title



app = tk.Frame(master=root)
app.grid(column=0,row=0)
#root.geometry('0x%d' % int(5+len(files)*44))
#app.pack()
#app.pack()



win = root
menubar = tk.Menu(win)
appmenu = tk.Menu(menubar, name='apple')
menubar.add_cascade(menu=appmenu)
appmenu.add_command(label='About my application')
appmenu.add_separator()
win['menu'] = menubar


def the_pref():
    import tkinter.messagebox
    x = tkinter.messagebox.askyesnocancel("test")
    print("...")
    print(x)
    print("...")

root.createcommand('::tk::mac::ShowPreferences', the_pref)

buttons = []

f_i = 0

for f in files:
    name=f.replace('_', ' ').split('.')[0]
    name=name[3:]
    button = tk.Button(app, width=9, height=2, text=name, command=lambda filename=f, directory=source_dir: starter(filename, directory))
    button.grid(column=int(f_i/f_i_max),row=f_i % f_i_max, padx=0, pady=0)
    f_i+=1

#print(os.getenv("SHELL"))
app.pack()

app.mainloop()
