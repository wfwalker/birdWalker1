// Imported TraX classes
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.Transformer;
import javax.xml.transform.stream.StreamSource;
import javax.xml.transform.stream.StreamResult;
import javax.xml.transform.TransformerException;
import javax.xml.transform.TransformerConfigurationException;


// Imported java classes
import java.io.FileOutputStream;
import java.io.FileNotFoundException;
import java.io.IOException;

// other imports
import java.util.*;
import java.io.*;

/**
 * Transform groups of XML files using XSL.
 */
public class BatchTransformer
{
	/** The Xalan Transformer currently in use. */
	private Transformer		mTransformer;
	
	/** How many files have been processed in this batch. */
	private int				mFilesProcessed;

	/** How many lame, busted Xalan transformers we needed to process that many files. */
	private int				mTransformers;

	/** The stylesheet file we're using to transform this batch. */
	private String			mStylesheet;

	/** The age of the stylesheet we're using. */
	private long			mStylesheetLastModified;

	/**
	 * Creates a new BatchTransformer using the given stylesheet.
	 */
	public BatchTransformer(String inStylesheet) throws TransformerConfigurationException
	{
		System.out.println("new BatchTransformer(" + inStylesheet + ")");

		mFilesProcessed = 0;
		mTransformers = 0;
		mStylesheet = inStylesheet;

		File tempStylesheet = new File(inStylesheet);
		mStylesheetLastModified = tempStylesheet.lastModified();

		getNewTransformer();
	}

	/**
	 * Creates a new Transformer for the style sheet associated with this BatchTransformer.
	 */
	private void getNewTransformer() throws TransformerConfigurationException
	{
		// Use the static TransformerFactory.newInstance() method to instantiate 
		// a TransformerFactory. The javax.xml.transform.TransformerFactory 
		// system property setting determines the actual class to instantiate --
		// org.apache.xalan.transformer.TransformerImpl.
		TransformerFactory tFactory = TransformerFactory.newInstance();
	
		// Use the TransformerFactory to instantiate a Transformer that will work with  
		// the stylesheet you specify. This method call also processes the stylesheet
		// into a compiled Templates object.
		mTransformer = tFactory.newTransformer(new StreamSource(mStylesheet));

		mTransformer.setParameter("in-tstamp", (new Date()).toString());

		mTransformers++;
	}

	/**
	 * Transform a single XML file, grabbing a new Transformer if the old
	 * one seems to have gone south.
	 */
	private void doTransform(File inSource, File inDest)
		throws IOException, TransformerException, TransformerConfigurationException
	{
		System.out.println(inSource + " --> " + inDest);
		
		FileOutputStream anOutStream = null;

		try
		{
			anOutStream = new FileOutputStream(inDest);

			mTransformer.transform(new StreamSource(inSource), new StreamResult(anOutStream));
			mFilesProcessed++;
		}
		catch (FileNotFoundException fnfe)
		{
			System.out.println("FILE NOT FOUND " + fnfe);
		}
		catch (TransformerException te)
		{
			System.out.println("Got transformer exception, building new transformer");

			anOutStream.close();
			inDest.delete();
			anOutStream = new FileOutputStream(inDest);

			getNewTransformer();
			mTransformer.transform(new StreamSource(inSource), new StreamResult(anOutStream));
			mFilesProcessed++;
		}
		finally
		{
			if (anOutStream != null)
			{
				anOutStream.close();
			}
		}
	}

	/**
	 * Recursively find the files in a directory that have a given suffix.
	 */
	private static void findFiles(Vector inVector, File inNode)
	{
		if (inNode.isFile() && inNode.getName().endsWith(".xml"))
		{
			// System.out.println("BASE CASE " + inNode);
			inVector.add(inNode);
		}
		else if (inNode.isDirectory())
		{
			// System.out.println("RECURSIVE CASE " + inNode);

			File[] contents = inNode.listFiles();

			for (int contentsIndex = 0; contentsIndex < contents.length; contentsIndex++)
			{
				findFiles(inVector, contents[contentsIndex]);
			}
		}
	}

	/**
	 * Update the files in the destination folder from the sources in the source tree
	 * using XSL, but only if the source is newer than the destination.
	 */
	public void updateFiles(String inSourceTree, String inDestTree)
	{
		try
		{
			Vector theSourceFiles = new Vector();
			findFiles(theSourceFiles, new File(inSourceTree));

			for (int sourceIndex = 0; sourceIndex < theSourceFiles.size(); sourceIndex++)
			{
				File aSource = (File) theSourceFiles.elementAt(sourceIndex);
				String aSourceName = aSource.getName();
				File aDest = new File(inDestTree + "/" + aSourceName.substring(0, aSourceName.indexOf(".")) + ".html");

				if (aDest.exists() && 
					(aDest.lastModified() > aSource.lastModified()) && 
					(aDest.lastModified() > mStylesheetLastModified))
				{
					System.out.println("SKIPPING " + aSource);
				}
				else
				{
					doTransform(aSource, aDest);
				}
			}
		}
		catch (IOException ioe)
		{
			System.out.println("Can't finish updating " + ioe);
			ioe.printStackTrace();
		}
		catch (TransformerException te)
		{
			System.out.println("Can't finish updating " + te);
			te.printStackTrace();
		}
	}

	/**
	 * Use the batch transformer to update the reports and indices for
	 * birdWalker, an XSLT-based birding field notes system.
	 */
	public static void main(String[] args)
	{  
		try
		{
			BatchTransformer reportTransform = new BatchTransformer("report-xsl/reports.xsl");
			reportTransform.updateFiles("sources/species", "html");
			reportTransform.updateFiles("sources/years", "html");
			reportTransform.updateFiles("sources/trips", "html");
			reportTransform.updateFiles("sources/locations", "html");
			reportTransform.updateFiles("sources/orders", "html");

			BatchTransformer indexTransform = new BatchTransformer("report-xsl/indices.xsl");
			indexTransform.updateFiles("sources/indices", "html");

			System.out.println("Reports Processed = " + reportTransform.mFilesProcessed);
			System.out.println("Report Transformers = " + reportTransform.mTransformers);

			System.out.println("Indices Processed = " + indexTransform.mFilesProcessed);
			System.out.println("Index Transformers = " + indexTransform.mTransformers);
		}
		catch (TransformerConfigurationException tce)
		{
			System.out.println("uh oh " + tce);
			tce.printStackTrace();
		}
	}
}
