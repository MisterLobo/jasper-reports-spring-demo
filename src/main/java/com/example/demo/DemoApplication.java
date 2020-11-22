package com.example.demo;

import net.sf.jasperreports.engine.DefaultJasperReportsContext;
import net.sf.jasperreports.engine.JRFont;
import net.sf.jasperreports.engine.JRPropertiesUtil;
import net.sf.jasperreports.engine.JasperReportsContext;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.builder.SpringApplicationBuilder;
import org.springframework.boot.web.servlet.support.SpringBootServletInitializer;
import org.springframework.util.ResourceUtils;

import java.io.File;
import java.io.FileNotFoundException;

@SpringBootApplication
public class DemoApplication extends SpringBootServletInitializer {

	private static void installFonts() throws FileNotFoundException {
		final JasperReportsContext jasperReportsContext = DefaultJasperReportsContext.getInstance();

		final JRPropertiesUtil jrPropertiesUtil = JRPropertiesUtil.getInstance(DefaultJasperReportsContext.getInstance());
		final File font = ResourceUtils.getFile("classpath:repository/JR-INF/libs/fonts/ttf/DejaVuSans.ttf");
		jrPropertiesUtil.setProperty(JRFont.DEFAULT_PDF_FONT_NAME, font.getAbsolutePath());
		jrPropertiesUtil.setProperty(JRFont.DEFAULT_PDF_ENCODING, "Identity-H");
		jrPropertiesUtil.setProperty(JRFont.DEFAULT_PDF_EMBEDDED, "TRUE");
		System.out.println("PDF Font: " + jrPropertiesUtil.getProperty(JRFont.DEFAULT_PDF_FONT_NAME));
		System.out.println("Font: " + jrPropertiesUtil.getProperty(JRFont.DEFAULT_FONT_NAME));
	}

	@Override
	protected SpringApplicationBuilder configure(SpringApplicationBuilder application) {
		return application.sources(DemoApplication.class);
	}

	public static void main(String[] args) throws FileNotFoundException {
		SpringApplication.run(DemoApplication.class, args);
		installFonts();
	}

}
