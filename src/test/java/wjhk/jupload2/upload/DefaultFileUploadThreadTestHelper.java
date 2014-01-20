//
// $Id$
//
// jupload - A file upload applet.
//
// Copyright 2012 The JUpload Team
//
// Created: 5 nov. 2012
// Creator: etienne_sf
// Last modified: $Date$
//
// This program is free software; you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation; either version 2 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this program; if not, write to the Free Software
// Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.

package wjhk.jupload2.upload;

import java.io.OutputStream;
import java.util.concurrent.BlockingQueue;

import wjhk.jupload2.exception.JUploadException;
import wjhk.jupload2.exception.JUploadIOException;
import wjhk.jupload2.policies.UploadPolicy;
import wjhk.jupload2.upload.DefaultFileUploadThread;
import wjhk.jupload2.upload.FileUploadManagerThread;
import wjhk.jupload2.upload.UploadFileData;
import wjhk.jupload2.upload.UploadFilePacket;

/**
 * 
 * This class is inherits from DefaultFileUploadThread, in order to allow execution of JUnit tests on the
 * DefaultFileUploadThread class.
 * 
 * All abstract method are implemented without actions.
 * 
 * @author etienne_sf
 *
 */
public class DefaultFileUploadThreadTestHelper extends DefaultFileUploadThread {

    /**
     * @param threadName
     * @param packetQueue
     * @param uploadPolicy
     * @param fileUploadManagerThread
     */
    public DefaultFileUploadThreadTestHelper(String threadName,
            BlockingQueue<UploadFilePacket> packetQueue,
            UploadPolicy uploadPolicy,
            FileUploadManagerThread fileUploadManagerThread) {
        super(threadName, packetQueue, uploadPolicy, fileUploadManagerThread);
        // TODO Auto-generated constructor stub
    }

    /**
     * @see wjhk.jupload2.upload.DefaultFileUploadThread#getAdditionnalBytesForUpload(wjhk.jupload2.upload.UploadFileData)
     */
    @Override
    long getAdditionnalBytesForUpload(UploadFileData uploadFileData)
            throws JUploadIOException {
        // TODO Auto-generated method stub
        return 0;
    }

    /**
     * @see wjhk.jupload2.upload.DefaultFileUploadThread#beforeRequest(wjhk.jupload2.upload.UploadFilePacket)
     */
    @Override
    void beforeRequest(UploadFilePacket packet) throws JUploadException {
        // TODO Auto-generated method stub

    }

    /**
     * @see wjhk.jupload2.upload.DefaultFileUploadThread#startRequest(long, boolean, int, boolean)
     */
    @Override
    void startRequest(long contentLength, boolean bChunkEnabled, int chunkPart,
            boolean bLastChunk) throws JUploadException {
        // TODO Auto-generated method stub

    }

    /**
     * @see wjhk.jupload2.upload.DefaultFileUploadThread#finishRequest()
     */
    @Override
    int finishRequest() throws JUploadException {
        // TODO Auto-generated method stub
        return 0;
    }

    /**
     * @see wjhk.jupload2.upload.DefaultFileUploadThread#interruptionReceived()
     */
    @Override
    void interruptionReceived() {
        // TODO Auto-generated method stub

    }

    /**
     * @see wjhk.jupload2.upload.DefaultFileUploadThread#beforeFile(wjhk.jupload2.upload.UploadFilePacket, wjhk.jupload2.upload.UploadFileData)
     */
    @Override
    void beforeFile(UploadFilePacket uploadFilePacket,
            UploadFileData uploadFileData) throws JUploadException {
        // TODO Auto-generated method stub

    }

    /**
     * @see wjhk.jupload2.upload.DefaultFileUploadThread#afterFile(wjhk.jupload2.upload.UploadFileData)
     */
    @Override
    void afterFile(UploadFileData uploadFileData) throws JUploadException {
        // TODO Auto-generated method stub

    }

    /**
     * @see wjhk.jupload2.upload.DefaultFileUploadThread#cleanRequest()
     */
    @Override
    void cleanRequest() throws JUploadException {
        // TODO Auto-generated method stub

    }

    /**
     * @see wjhk.jupload2.upload.DefaultFileUploadThread#cleanAll()
     */
    @Override
    void cleanAll() throws JUploadException {
        // TODO Auto-generated method stub

    }

    /**
     * @see wjhk.jupload2.upload.DefaultFileUploadThread#getOutputStream()
     */
    @Override
    OutputStream getOutputStream() throws JUploadException {
        // TODO Auto-generated method stub
        return null;
    }

}
