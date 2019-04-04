package io.opencaesar.oml.dsl.naming

import org.eclipse.xtext.naming.QualifiedName
import org.eclipse.xtext.scoping.impl.ImportNormalizer

class OmlNamespaceImportNormalizer extends ImportNormalizer{
	
	val String nsPrefix
	val QualifiedName nsURI

	new(QualifiedName nsURI, String nsPrefix, boolean ignoreCase) {
		super(nsURI, false, ignoreCase);
		this.nsPrefix = nsPrefix;
		this.nsURI = nsURI;
	}
	
	override QualifiedName resolve(QualifiedName relativeName) {
		val last = relativeName.getLastSegment();
		if (last.contains(":")) {
			val data = last.split(":");
			if ((data.get(0)) == nsPrefix) {
				val x = nsURI.append(QualifiedName.create(data.get(1)));
				return x;
			}
			
		}
		return null;
	}
	
	override QualifiedName deresolve(QualifiedName fullyQualifiedName) {
		val name = fullyQualifiedName.skipFirst(nsURI.getSegmentCount());
		if (name.getSegmentCount() == 1) {
			val parentQualifiedName = fullyQualifiedName.skipLast(1)
			if (parentQualifiedName == nsURI) {
				val x = QualifiedName.create(nsPrefix+":"+name.getLastSegment());
				return x;
			}
		}
		return null;
	}

}