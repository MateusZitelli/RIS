require "RMagick"
require "narray"
include Magick
$letras = %w[0 1 \ ]
$letras << " "

class Letras
	def initialize
		puts "Quantidade de letras no eixo de maior tamanho:"
		@@tamImagem = gets.chomp.to_i
		@@img = Image.read("gnu.png")[0]

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
	def gerar(x=0)
	  (@@img2R.size).times do |vez|
			@@file << '
' if vez % @@img.columns == 0 and vez != 0 and (x == 2 or x == 1)
			@@file << $letras[(@@img2[vez]*($letras.size-1))/255] if x == 0 or x == 2
			@@file << $letras[(@@img2[vez]*($letras.size-1))/255]*2 if x == 1
		end
  end

	def pintar_cor
	  gerar()
		puts "Tamanho da fonte:"
		@@tamFonte = gets.chomp.to_i
		@@gc.pointsize(@@tamFonte)
		@@gc.fill("white")
		(@@img2.size).times do |x|
		  @@gc.fill("rgb("+@@img2R[x].to_s+","+@@img2G[x].to_s+","+@@img2B[x].to_s+")")
		  @@gc.text(x%@@img.columns*(@@tamFonte-@@tamFonte/5),x/@@img.columns*(@@tamFonte-@@tamFonte/5),@@file[x].chr)
    end
		@imgFinal = Image.new(@@img.columns*(@@tamFonte-@@tamFonte/5),@@img.rows*(@@tamFonte-@@tamFonte/5)){self.background_color = "black"}
		@@gc.draw(@imgFinal)
		@imgFinal.display
		puts "Deseja salvar: (y/n)"
		yn = gets.chomp.downcase
		puts "Nome?" if yn == "y"
		@imgFinal.write(gets.chomp) if yn == "y"
	end

	def pintar_pb
	  gerar()
		puts "Tamanho da fonte:"
		@@tamFonte = gets.chomp.to_i
		@@gc.pointsize(@@tamFonte)
		@@gc.fill("white")
		(@@img2.size).times do |x|
		  @@gc.text(x%@@img.columns*(@@tamFonte-@@tamFonte/5),x/@@img.columns*(@@tamFonte-@@tamFonte/5),@@file[x].chr)
    end
		@imgFinal = Image.new(@@img.columns*(@@tamFonte-@@tamFonte/5),@@img.rows*(@@tamFonte-@@tamFonte/5)){self.background_color = "black"}
		@@gc.draw(@imgFinal)
		@imgFinal.display
		puts "Deseja salvar: (y/n)"
		yn = gets.chomp.downcase
		puts "Nome?" if yn == "y"
		@imgFinal.write(gets.chomp) if yn == "y"
	end

	def escrever
	  gerar(1)
		puts "Nome do arquivo:"
		@texto = File.new(gets.chomp,"w")
		@@file.each_line do |line|
			@texto.print line
		end
	end
end

teste = Letras.new
teste.pintar_pb
