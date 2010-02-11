require "RMagick"
require "narray"
include Magick
$letras = %w[1 0]
$letras << " "

class Letras
	def initialize
		puts "Quantidade de letras no eixo de maior tamanho:"
		@@tamImagem = gets.chomp.to_i
		@@img = Image.read("teste3.jpg")[0]
		if @@img.columns > @@img.rows
			@eixoX = @@img.columns.to_f / @@tamImagem
			@@img = @@img.resize(@@tamImagem,@@img.rows/@eixoX)
		else
			@eixoY = @@img.rows.to_f / @@tamImagem
			@@img = @@img.resize(@@img.columns/@eixoY,@@tamImagem)
		end
		@@img2 = @@img.export_pixels_to_str(0,0,@@img.columns,@@img.rows,"I",CharPixel)
		@@img2R = @@img.export_pixels_to_str(0,0,@@img.columns,@@img.rows,"R",CharPixel)
		@@img2G = @@img.export_pixels_to_str(0,0,@@img.columns,@@img.rows,"G",CharPixel)
		@@img2B = @@img.export_pixels_to_str(0,0,@@img.columns,@@img.rows,"B",CharPixel)

		@@img2 = NArray.to_na(@@img2,NArray::BYTE,@@img.columns,@@img.rows)
		@@img2R = NArray.to_na(@@img2R,NArray::BYTE,@@img.columns,@@img.rows)
		@@img2G = NArray.to_na(@@img2G,NArray::BYTE,@@img.columns,@@img.rows)
		@@img2B = NArray.to_na(@@img2B,NArray::BYTE,@@img.columns,@@img.rows)

		@@file = String.new
		@@gc = Draw.new
	end

	def pintar_cor
	  (@@img2.size).times do |vez|
			@@file << $letras[(@@img2[vez]*($letras.size-1))/255]*2
		end
		puts "Tamanho da fonte:"
		@@tamFonte = gets.chomp.to_i
		@@gc.pointsize(@@tamFonte)
		times = @@tamFonte
		@locLx=0
		@locLy=@@tamFonte
		@@gc.fill("white")
		(@@img2.size).times do |x|
		  @@gc.fill("rgb("+@@img2R[x].to_s+","+@@img2G[x].to_s+","+@@img2B[x].to_s+")")
		  @@gc.text(@locLx%@@img.columns*@@tamFonte,@locLx/@@img.columns*@@tamFonte+@@tamFonte,@@file[x].chr)
		  @locLx += 1
    end
		@imgFinal = Image.new(@@img.columns*@@tamFonte,@@img.rows*@@tamFonte){self.background_color = "black"}
		@@gc.draw(@imgFinal)
		@imgFinal.display
		puts "Deseja salvar: (y/n)"
		yn = gets.chomp.downcase
		puts "Nome?" if yn == "y"
		@imgFinal.write(gets.chomp) if yn == "y"
	end

	def pintar_pb
		puts "Tamanho da fonte:"
		@@tamFonte = gets.chomp.to_i
		@@gc.pointsize(@@tamFonte)
		times = @@tamFonte
		@@gc.fill("black")
		#@@file.each_line do |line|           ##################
		#	@@gc.text(0,times,line)             #Create the image#
		#	times += @@tamFonte #pula uma linha #linha per linha #
		#end                                  ##################
		@@gc.text(0,@@tamFonte,@@file)
		@imgFinal = Image.new(@@img.columns*@@tamFonte,@@img.rows*@@tamFonte)
		@imgFinal.background_color = "white"
		@@gc.draw(@imgFinal)
		@imgFinal.display
		puts "Deseja salvar: (y/n)"
		yn = gets.chomp.downcase
		puts "Nome?" if yn == "y"
		@imgFinal.write(gets.chomp) if yn == "y"
	end

	def escrever
	  (@@img2R.size).times do |vez|
			@@file << '
' if vez % @@img.columns == 0 and vez != 0
			@@file << $letras[(@@img2[vez]*($letras.size-1))/255]*2
		end
		puts "Nome do arquivo:"
		@texto = File.new(gets.chomp,"w")
		@@file.each_line do |line|
			@texto.print line
		end
	end
end

teste = Letras.new
puts "Draw Color Image, Draw BW Image or Write (drawcolor/drawbw/write)"
varteste = gets.chomp.downcase
if varteste == "drawbw"
	teste.pintar_pb
elsif varteste == "drawcolor"
	teste.pintar_cor
elsif varteste == "write"
  teste.escrever
end

