import sublime
import sublime_plugin
import datetime
import subprocess


class TurboSafelinkCommand(sublime_plugin.TextCommand):

    def run(self, edit):
        for region in self.view.sel():
            self.handle_region(edit, region)

    def handle_region(self, edit, region):
        x = self.view.substr(region)

        import urllib.parse
        all = urllib.parse.unquote(x)
        l = all.split("&")[0].split("url=")[1]
        self.view.replace(edit, region, l)

class TurboDokuWikiTableCommand(sublime_plugin.TextCommand):

    def run(self, edit):
        for region in self.view.sel():
            self.handle_region(edit, region)

    def handle_region(self, edit, region):
        import base64
        x = self.view.substr(region)


        lines = x.strip().split("\n")
        lines = [l.strip() for l in lines if not len(l.strip())==0]

        heads = False
        if '^' in lines[0]:
            lines[0] = lines[0].replace('^', '|')
            heads = True

        cols = len(lines[0].split("|"))-2
        widths = []
        for col in range(0,cols):
            m = 0
            for line in lines:
                cols_ = line.split("|")[1:-1]
                if m < len(cols_[col].strip()):
                    m = len(cols_[col].strip())
            widths.append(m)
        
        fstring = "|"
        for w in widths:
            fstring += " %%-%ds |" % w

        padded_lines = []
        for line in lines:
            cols_ = line.split("|")[1:-1]
            cols_ = [ c.strip() for c in cols_]
            padded_lines.append(fstring % tuple(cols_))

        if heads == True:
            padded_lines[0] = padded_lines[0].replace("|", "^")

        self.view.replace(edit, region, "\n".join(padded_lines))


class TurboGrepCommand(sublime_plugin.TextCommand):

    def run(self, edit):
        for region in self.view.sel():
            self.handle_region(edit, region)

    def handle_region(self, edit, region):
        import base64
        x = self.view.substr(region)

        lines = x.strip().split("\n")

        needle = lines[0].upper()
        lines = lines[1:]
        filtered_lines = [l for l in lines if l.upper().find(needle) >= 0]
        self.view.replace(edit, region, "\n".join(filtered_lines))


class TurboDokuWikiTilesCommand(sublime_plugin.TextCommand):

    def run(self, edit):
        for region in self.view.sel():
            self.handle_region(edit, region)

    def tile(self, id, title, tile_counter):
        return """<a accesskey="%d" href="?id=%s" style="text-decoration: none; color: silver; font-weight: bold;"><div onclick="location.href='?id=%s';" style="cursor: pointer; margin: 5px; float: left; text-align:center; v-align: middle; width: 150px; height: 50px; background: white; border: 1px dashed silver; line-height: 50px; font-size: 115%%;">%s</div></a>\n""" % (tile_counter, id, id, title)

    def tiles(self, data):
        wikilinks=[]
        lines = data.split("\n")
        o="<html>\n"
        o+="<!--\n"
        for line in lines:
            if line.strip().startswith("tile"):
                cols = [ col.strip() for col in line.strip().split(';')]
                page_id = cols[1]
                title = cols[2]
                o+="tile ; %-20s ; %s\n" % (page_id, title)
        o+="-->\n"
        tile_counter=0
        for line in lines:
            if line.strip().startswith("tile"):
                tile_counter+=1
                cols = [ col.strip() for col in line.strip().split(';')]
                page_id = cols[1]
                title = cols[2]
                wikilinks.append("[[%s|%s]]" % (page_id, title))
                o+=self.tile(page_id, "%d:%s" % (tile_counter, title), tile_counter)
                #if tile_counter%4==0:
                #    o+="<div style=\"clear: both;\"></div>\n"
        o+="<div style=\"clear: both;\"></div>\n"
        o+="</html>\n"

        o+="\n"
        o+=" | ".join(wikilinks)
        o+="\n"

        return o

    def handle_region(self, edit, region):
        import base64
        x = self.view.substr(region)
        self.view.replace(edit, region, self.tiles(x))

class TurboHelpCommand(sublime_plugin.TextCommand):

    def run(self, edit):
        for region in self.view.sel():
            self.handle_region(edit, region)

    def handle_region(self, edit, region):
        import base64
        help_text="""
Turbo Commands for Subime 3
***************************

C-CMD-b   Selection to base64
C-CMD-B   Selection from base64 to plain UTF-8
C-CMD-m   Create javascript Bookmark
C-CMD-t   Selection format DokuWiki table
C-CMD-n   Selection format DokuWiki Index Tiles
C-CMD-j   Justify

"""
        self.view.replace(edit, region, help_text)

class TurboUnderlineCommand(sublime_plugin.TextCommand):

    def run(self, edit):
        for region in self.view.sel():
            self.handle_region(edit, region)

    def handle_region(self, edit, region):
        lines = self.view.substr(region).split("\n")
        line = lines[0]
        the_char="="

        if len(lines) > 1:
            if lines[1].startswith("="):
                the_char = "#"
            if lines[1].startswith("#"):
                the_char = "-"

        self.view.replace(edit, region, line + "\n" + the_char*len(line) + "\n")

class TurboItemizeCommand(sublime_plugin.TextCommand):

    def run(self, edit):
        for region in self.view.sel():
            self.handle_region(edit, region)

    def handle_region(self, edit, region):
        lines = self.view.substr(region).split("\n")
        line = lines[0]
        self.view.replace(edit, region, "items: " + line)


class TurboBookmarkCommand(sublime_plugin.TextCommand):

    def run(self, edit):
        for region in self.view.sel():
            self.handle_region(edit, region)

    def handle_region(self, edit, region):
        import base64
        x = self.view.substr(region)
        self.view.replace(edit, region, "javascript:eval(atob('%s'))" % base64.b64encode(x.encode()).decode())

class TurboBaseCommand(sublime_plugin.TextCommand):

    def run(self, edit):
        for region in self.view.sel():
            self.handle_region(edit, region)

    def handle_region(self, edit, region):
        import base64
        x = self.view.substr(region)
        self.view.replace(edit, region, base64.b64encode(x.encode()).decode())

class TurboJsonCommand(sublime_plugin.TextCommand):

    def run(self, edit):
        for region in self.view.sel():
            self.handle_region(edit, region)

    def handle_region(self, edit, region):
        import json
        x = self.view.substr(region)
        self.view.replace(edit, region, json.dumps({'x': x}))

class TurboJustCommand(sublime_plugin.TextCommand):

    def run(self, edit):
        for region in self.view.sel():
            self.handle_region(edit, region)

    def handle_region(self, edit, region):
        import textwrap
        x = self.view.substr(region)
        #self.view.replace(edit, region, textwrap.fill(x, width=64))
        self.view.replace(edit, region, "\n\n".join(textwrap.wrap(x, width=64)))

class TurboUnBaseCommand(sublime_plugin.TextCommand):

    def run(self, edit):
        for region in self.view.sel():
            self.handle_region(edit, region)

    def handle_region(self, edit, region):
        import base64
        x = self.view.substr(region)
        self.view.replace(edit, region, base64.b64decode(x.encode()).decode())


class Time2Command(sublime_plugin.EventListener):

    def tsx_string(self):
        return """import Link from 'next/link'
import { GetServerSideProps } from 'next'

const Robert = ({data}: Props) => (
    <div>OKAY {data.ok}</div>
)

export default Robert

export const getServerSideProps: GetServerSideProps = async (context) => {
    const res = await fetch("http://127.0.0.1:8080/ok")
    const data = await res.json()
    return {
        props: {
            data
        }
    }
}

"""

    def on_query_completions(self, view, prefix, locations):
        print("moep(%s)" % prefix)
        if prefix == "nnn":
            uuidstring = subprocess.check_output(["uuidgen"], universal_newlines=True).lower().strip().replace("-", "")
            #print(uuidstring)
            return [(prefix, prefix, "module module_" + uuidstring + "() {\n}\n")]
        #if (prefix == "nnn"):
        #    uuidstring = subprocess.check_output(["uuidgen"], universal_newlines=True).lower().strip().replace("-", "")
        #    return "\nmodule mod%s() {\n}\n" % (uuidstring)
        timestring = datetime.datetime.now(datetime.timezone.utc).astimezone().isoformat().replace("+", " ").replace(".", " ").split()
        timestring = "%s+%s" % (timestring[0], timestring[2])
        if (prefix == "tz"):
            return [(prefix, prefix, datetime.datetime.now().isoformat().split(".")[0])]
        if (prefix == "t"):
            return [(prefix, prefix, timestring)]
        if (prefix == "tsx"):
            return [(prefix, prefix, self.tsx_string())]
        if (prefix == "u"):
            uuidstring = subprocess.check_output(["uuidgen"], universal_newlines=True).lower().strip()
            return [(prefix, prefix, uuidstring)]
        if (prefix == "R"):
            tmp_str = """with open("", "r") as f:
    lines = f.read().strip().replace("\\r", "").split("\\n")
            """
            return [(prefix, prefix, tmp_str)]
        if (prefix == "U"):
            uuidstring = subprocess.check_output(["uuidgen"], universal_newlines=True)
            return [(prefix, prefix, uuidstring)]
        if (prefix == "h8"):
            uuidstring = subprocess.check_output(["openssl", "rand", "-hex", "4"], universal_newlines=True).lower()
            return [(prefix, prefix, uuidstring)]
        if (prefix == "h32"):
            uuidstring = subprocess.check_output(["openssl", "rand", "-hex", "16"], universal_newlines=True).lower()
            return [(prefix, prefix, uuidstring)]
        if (prefix == "dt"):
            uuidstring = subprocess.check_output(["date", "+%F"], universal_newlines=True).strip()
            return [(prefix, prefix, uuidstring)]
        if (prefix == "mfg"):
            return [(prefix, prefix, "\nMit freundlichen Grüßen\n\nRobert Degen\n")]
        if (prefix == "vg"):
            return [(prefix, prefix, "\nViele Grüße\n\nRobert\n")]
        if (prefix == "gr"):
            return [(prefix, prefix, "\nGreetings\n\nRobert\n")]
        if (prefix == "br"):
            return [(prefix, prefix, "\nBest regards,\n\nRobert\n")]
        if (prefix == "ct"):
            return [(prefix, prefix, "center=true")]
        if (prefix == "tr"):
            return [(prefix, prefix, "translate([0,0,0])")]
        if (prefix == "ro"):
            return [(prefix, prefix, "rotate([0,0,0])")]
        if (prefix == "sh"):
            return [(prefix, prefix, """o = subprocess.check_output("", shell=True, universal_newlines=True)""")]
        if (prefix == "cyz"):
            return [(prefix, prefix, "translate([0,0,0]) cylinder(d=8, h=1, center=true, \$fn=50)")]
        if (prefix == "cyx"):
            return [(prefix, prefix, "translate([0,0,0]) rotate([0,90,0]) cylinder(d=8, h=1, center=true, \$fn=50)")]
        if (prefix == "cyy"):
            return [(prefix, prefix, "translate([0,0,0]) rotate([90,0,0]) cylinder(d=8, h=1, center=true, \$fn=50)")]
        if (prefix == "cyznc"):
            return [(prefix, prefix, "translate([0,0,0]) cylinder(d=8, h=1, center=false, \$fn=50)")]
        if (prefix == "cyxnc"):
            return [(prefix, prefix, "translate([0,0,0]) rotate([0,90,0]) cylinder(d=8, h=1, center=false, \$fn=50)")]
        if (prefix == "cyync"):
            return [(prefix, prefix, "translate([0,0,0]) rotate([90,0,0]) cylinder(d=8, h=1, center=false, \$fn=50)")]
        if (prefix == "cu"):
            return [(prefix, prefix, "translate([0,0,0]) cube([1,1,1], center=true)")]
        if (prefix == "sp"):
            return [(prefix, prefix, "translate([0,0,0]) sphere(d=10, \$fn=100)")]
        if (prefix == "w"):
            return [(prefix, prefix, "translate([0,0,0]) cube([10,10,10], center=true)")]
        if (prefix == "cr"):
            return [(prefix, prefix, "translate([+1,+1,0])\ntranslate([-1,+1,0])\ntranslate([+1,-1,0])\ntranslate([-1,-1,0])\n")]
        if (prefix == "ra"):
            # raster
            return [(prefix, prefix, "// auto raster BEGIN =========================\nraster_nx=2;\nraster_ny=3;\nraster_dx=20;\nraster_dy=30;\nfor (raster_x=[0:raster_nx-1]) for (raster_y=[0:raster_ny-1]) {\n    translate([raster_dx*raster_x, raster_dy*raster_y, 0])\n        cube([2,2,2]); // replace with your object code\n}\n// auto raster END =========================\n")]
        return []
